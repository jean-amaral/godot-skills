# Testes da skill godot-audio-cinematics: CutscenePlayer (tocar, batida, pulo).
# Uso: $env:GODOT_PATH="...Godot_v*_console.exe"; .\run_tests.ps1 [-WorkRoot <dir>]
param([string]$GodotPath = $env:GODOT_PATH, [string]$WorkRoot = "")

if (-not $GodotPath) {
    $cmd = Get-Command godot -ErrorAction SilentlyContinue
    if ($cmd) { $GodotPath = $cmd.Source }
}
if (-not $GodotPath -or -not (Test-Path $GodotPath)) {
    Write-Host "FAIL runner :: defina GODOT_PATH para o executavel console da Godot 4.7+"
    exit 1
}
$testsRoot = $PSScriptRoot
$skillRoot = Split-Path $testsRoot -Parent
$workRoot = if ($WorkRoot) { $WorkRoot } else {
    Join-Path ([Environment]::GetFolderPath('LocalApplicationData')) "Temp\godot-audio-cinematics-tests"
}
if (Test-Path $workRoot) { Remove-Item $workRoot -Recurse -Force }
$project = Join-Path $workRoot "project"
New-Item -ItemType Directory -Force -Path $project | Out-Null
Copy-Item (Join-Path $testsRoot "project\*") $project -Recurse -Force
New-Item -ItemType Directory -Force -Path (Join-Path $project "scripts") | Out-Null
Copy-Item (Join-Path $skillRoot "scripts\*.gd") (Join-Path $project "scripts") -Force
$env:APPDATA = Join-Path $workRoot "appdata"
New-Item -ItemType Directory -Force -Path $env:APPDATA | Out-Null

function Run-Godot([string[]]$godotArgs) {
    $info = New-Object System.Diagnostics.ProcessStartInfo
    $info.FileName = $GodotPath
    $info.Arguments = ((@("--headless", "--path", $project) + $godotArgs | ForEach-Object { '"' + $_ + '"' }) -join " ")
    $info.UseShellExecute = $false
    $info.RedirectStandardOutput = $true
    $info.RedirectStandardError = $true
    $info.CreateNoWindow = $true
    $proc = [System.Diagnostics.Process]::Start($info)
    $stdoutTask = $proc.StandardOutput.ReadToEndAsync()
    $stderrTask = $proc.StandardError.ReadToEndAsync()
    if (-not $proc.WaitForExit(120000)) {
        try { $proc.Kill() } catch {}
        return @{ Out = "TIMEOUT"; Exit = 124 }
    }
    return @{ Out = ($stdoutTask.Result + $stderrTask.Result); Exit = $proc.ExitCode }
}

$r = Run-Godot @("--import", "--quit")
if ($r.Exit -ne 0) { Write-Host "FAIL import"; exit 1 }
$r = Run-Godot @("--script", "res://test_cutscene.gd")
if ($r.Exit -eq 0 -and $r.Out -match "CUTSCENE_DONE failures=0") {
    Write-Host "PASS cutscene (tocar/batida/pulo)"
    Write-Host "== RESULTADO: 1 passaram, 0 falharam"
    exit 0
}
Write-Host "FAIL cutscene"
$r.Out | Select-String -Pattern "FAIL .*|SCRIPT ERROR.*" | ForEach-Object { $_.Line }
exit 1
