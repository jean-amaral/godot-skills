# godot-plugins-installer (Windows). ASCII only (PowerShell 5.1).
# Downloads the pinned official releases of Phantom Camera, CSG Blockout and
# Godot AI, and copies each add-on into <project>/addons/<name>.
# It never overwrites an existing add-on without -Force, never enables the
# plugin for you (do it in Godot: Project > Project Settings > Plugins), and
# never installs from anywhere but the three official GitHub repos below.
#
#   .\install_plugins.ps1 -Project C:\games\meu-jogo
#   .\install_plugins.ps1 -Project C:\games\meu-jogo -Plugins phantom,csg
#   .\install_plugins.ps1 -Project C:\games\meu-jogo -Force   # replace add-ons
param(
    [Parameter(Mandatory = $true)][string]$Project,
    [string[]]$Plugins = @("phantom", "csg", "godotai"),
    [switch]$Force
)
$ErrorActionPreference = "Stop"

$Catalog = @{
    phantom = @{
        Name    = "phantom_camera"
        Version = "0.11.0.3"
        Url     = "https://github.com/ramokz/phantom-camera/archive/refs/tags/v0.11.0.3.zip"
        Sha256  = ""
    }
    csg = @{
        Name    = "csg_blockout"
        Version = "3.1.0"
        Url     = "https://github.com/qwqzhanqwq/Godot-CSG-Blockout/releases/download/v3.1.0/csg_blockout-3.1.0.zip"
        Sha256  = ""
    }
    godotai = @{
        Name    = "godot_ai"
        Version = "4.3.0"
        Url     = "https://github.com/hi-godot/godot-ai/releases/download/v4.3.0/godot-ai-v4-plugin.zip"
        Sha256  = ""
    }
}

function Get-Sha256Hex([string]$path) {
    $sha = [System.Security.Cryptography.SHA256]::Create()
    $stream = [System.IO.File]::OpenRead($path)
    try { return ([System.BitConverter]::ToString($sha.ComputeHash($stream)) -replace "-", "").ToLower() }
    finally { $stream.Dispose(); $sha.Dispose() }
}

$projectFull = [System.IO.Path]::GetFullPath($Project)
if (-not (Test-Path (Join-Path $projectFull "project.godot"))) {
    throw "project.godot not found in $projectFull - point -Project at a Godot project root."
}
$configVersion = (Select-String -Path (Join-Path $projectFull "project.godot") -Pattern "config_version").Line
Write-Host "Project: $projectFull ($configVersion)"

$tmp = Join-Path $env:TEMP ("godot-plugins-" + [Guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Force -Path $tmp | Out-Null
try {
    foreach ($key in $Plugins) {
        if (-not $Catalog.ContainsKey($key)) { Write-Host "WARN unknown plugin: $key (use phantom, csg, godotai)"; continue }
        $info = $Catalog[$key]
        $dest = Join-Path $projectFull ("addons\" + $info.Name)
        if ((Test-Path $dest) -and -not $Force) {
            $cfg = Join-Path $dest "plugin.cfg"
            $found = if (Test-Path $cfg) { (Select-String -Path $cfg -Pattern "^version=").Line } else { "no plugin.cfg" }
            Write-Host "SKIP $($info.Name): already installed ($found). Use -Force to replace it, or update it the plugin's own way (godot_ai: Update button in its dock)."
            continue
        }
        $zip = Join-Path $tmp "$key.zip"
        Write-Host "Downloading $($info.Name) $($info.Version) from $($info.Url)"
        Invoke-WebRequest -Uri $info.Url -OutFile $zip -UseBasicParsing -Headers @{ "User-Agent" = "godot-plugins-installer" }

        if ($info.ContainsKey("ShaUrl")) {
            $shaFile = Join-Path $tmp "$key.sha256"
            Invoke-WebRequest -Uri $info.ShaUrl -OutFile $shaFile -UseBasicParsing -Headers @{ "User-Agent" = "godot-plugins-installer" }
            $expected = ([regex]::Match((Get-Content $shaFile -Raw), "[a-fA-F0-9]{64}")).Value.ToLower()
            $actual = Get-Sha256Hex $zip
            if ($expected -ne $actual) { throw "SHA-256 mismatch for $key (expected $expected, got $actual). Nothing installed for this plugin." }
            Write-Host "SHA-256 verified for $($info.Name)."
        }

        $extract = Join-Path $tmp $key
        Expand-Archive -Path $zip -DestinationPath $extract -Force
        $pluginCfg = Get-ChildItem $extract -Recurse -Filter "plugin.cfg" |
            Where-Object { $_.Directory.Name -eq $info.Name } |
            Sort-Object { (Get-ChildItem $_.Directory -Recurse -File).Count } -Descending | Select-Object -First 1
        if (-not $pluginCfg) { throw "plugin.cfg of $($info.Name) not found inside the downloaded archive. Nothing installed for this plugin." }
        New-Item -ItemType Directory -Force -Path (Join-Path $projectFull "addons") | Out-Null
        if (Test-Path $dest) { Remove-Item $dest -Recurse -Force }
        Copy-Item $pluginCfg.Directory.FullName $dest -Recurse -Force
        $installed = (Select-String -Path (Join-Path $dest "plugin.cfg") -Pattern "^version=").Line
        Write-Host "INSTALLED $($info.Name) -> $dest ($installed)"
    }
} finally {
    Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
}
Write-Host ""
Write-Host "Next steps in Godot: Project > Project Settings > Plugins - enable each new plugin."
Write-Host "Phantom Camera: enabling registers the PhantomCameraManager autoload. Godot AI: open its dock and press Configure for your MCP client (requires uv installed), then restart the client."
