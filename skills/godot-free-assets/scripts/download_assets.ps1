# Baixa assets APROVADOS (CC0/CC-BY) de um manifesto JSON, com SHA-256,
# asset_manifest.json e CREDITS.md no destino. Sem -Approved: so valida e lista.
# Uso:
#   .\download_assets.ps1 -Manifest .\itens.json -Destination C:\projeto\assets\external -Approved [-Extract]
param(
    [Parameter(Mandatory = $true)][string]$Manifest,
    [Parameter(Mandatory = $true)][string]$Destination,
    [switch]$Approved,
    [switch]$Extract
)

$ErrorActionPreference = "Stop"
$allowedLicense = '^CC0( 1\.0)?$|^CC BY (3\.0|4\.0)$'

if (-not (Test-Path $Manifest)) { throw "Manifesto nao encontrado: $Manifest" }
$data = Get-Content $Manifest -Raw | ConvertFrom-Json
$items = @($data.items)
if ($items.Count -eq 0) { throw "Manifesto sem items." }

# Validacao completa ANTES de qualquer download: licenca, URL e nome de arquivo.
foreach ($item in $items) {
    if ([string]$item.license -notmatch $allowedLicense) {
        throw "Licenca fora do criterio (so CC0/CC-BY): '$($item.license)' em $($item.name)"
    }
    if ([string]$item.downloadUrl -notmatch '^https://') {
        throw "downloadUrl precisa ser https:// : $($item.downloadUrl)"
    }
    if ([string]$item.fileName -match '[/\\]' -or [string]$item.fileName -match '\.\.') {
        throw "fileName deve ser nome simples, sem caminho: $($item.fileName)"
    }
    if (-not $item.name -or -not $item.author -or -not $item.sourcePage) {
        throw "Item sem name/author/sourcePage completos: $($item.name)"
    }
}

if (-not $Approved) {
    Write-Host "DRY-RUN (nada baixado). $($items.Count) item(ns) valido(s):"
    $items | ForEach-Object { Write-Host " - $($_.name) [$($_.license)] $($_.downloadUrl)" }
    Write-Host "Rode de novo com -Approved para baixar."
    exit 0
}

New-Item -ItemType Directory -Force -Path $Destination | Out-Null
$manifestPath = Join-Path $Destination "asset_manifest.json"
$entries = @()
if (Test-Path $manifestPath) {
    $entries = @((Get-Content $manifestPath -Raw | ConvertFrom-Json).items)
}

$headers = @{ "User-Agent" = "godot-free-assets/1.0 (asset download for a Godot project)" }
foreach ($item in $items) {
    $target = Join-Path $Destination $item.fileName
    Invoke-WebRequest -Uri $item.downloadUrl -OutFile $target -Headers $headers -UseBasicParsing
    $hash = (Get-FileHash $target -Algorithm SHA256).Hash.ToLowerInvariant()
    if ($item.expectedSha256 -and $item.expectedSha256.ToLowerInvariant() -ne $hash) {
        Remove-Item $target -Force
        throw "SHA-256 divergente em $($item.fileName): esperado $($item.expectedSha256), obtido $hash. Arquivo removido."
    }
    $entries = @($entries | Where-Object { $_.fileName -ne $item.fileName })
    $entries += [ordered]@{
        name = $item.name; author = $item.author; sourcePage = $item.sourcePage
        license = $item.license; licenseUrl = $item.licenseUrl
        licenseEvidence = $item.licenseEvidence; downloadUrl = $item.downloadUrl
        fileName = $item.fileName; changes = $item.changes
        sha256 = $hash; bytes = (Get-Item $target).Length
        downloaded = (Get-Date).ToString("yyyy-MM-dd")
    }
    Write-Host "OK $($item.fileName) sha256=$hash"

    if ($Extract -and $item.fileName -match '\.zip$') {
        $extractDir = Join-Path $Destination ([IO.Path]::GetFileNameWithoutExtension($item.fileName))
        New-Item -ItemType Directory -Force -Path $extractDir | Out-Null
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        $zip = [System.IO.Compression.ZipFile]::OpenRead($target)
        try {
            foreach ($entry in $zip.Entries) {
                $destPath = [IO.Path]::GetFullPath((Join-Path $extractDir $entry.FullName))
                if (-not $destPath.StartsWith([IO.Path]::GetFullPath($extractDir))) {
                    throw "Entrada de zip escapa da pasta (zip-slip): $($entry.FullName)"
                }
                if ($entry.FullName -notmatch '/$') {
                    New-Item -ItemType Directory -Force -Path (Split-Path $destPath -Parent) | Out-Null
                    [System.IO.Compression.ZipFileExtensions]::ExtractToFile($entry, $destPath, $true)
                }
            }
        } finally { $zip.Dispose() }
        Write-Host "EXTRAIDO $extractDir"
    }
}

@{ items = $entries } | ConvertTo-Json -Depth 5 | Set-Content $manifestPath -Encoding UTF8

$credits = @("# Creditos de assets externos", "",
    "Assets baixados com a skill godot-free-assets (somente CC0/CC-BY).", "")
foreach ($e in $entries) {
    $credits += ('- "' + $e.name + '" por ' + $e.author + ' - ' + $e.sourcePage)
    $credits += ('  Licenca: ' + $e.license + ' - ' + $e.licenseUrl)
    $credits += ('  Alteracoes: ' + $e.changes + ' - SHA-256: ' + $e.sha256)
    $credits += ""
}
$credits | Set-Content (Join-Path $Destination "CREDITS.md") -Encoding UTF8
Write-Host "Manifesto e CREDITS.md atualizados em $Destination"
