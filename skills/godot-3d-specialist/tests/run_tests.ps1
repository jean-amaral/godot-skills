# Suite permanente da skill godot-3d-specialist (Windows/PowerShell).
# Uso:  $env:GODOT_PATH="C:\...\Godot_v4.7.2-stable_win64_console.exe"; .\run_tests.ps1
# Sem GODOT_PATH, procura "godot" no PATH. Sai 1 se qualquer caso falhar.
param([string]$GodotPath = $env:GODOT_PATH, [string]$WorkRoot = "")

$ErrorActionPreference = "Continue"
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

# Executa numa copia em diretorio temporario SEM espaco no caminho:
# --path com espaco ("New Folder") e APPDATA dentro do workspace quebram
# a Godot/CLI no Windows. A fonte continua sendo tests/project + ../scripts.
# LocalApplicationData\Temp (e nao %TEMP%): em ambientes com TEMP remapeado
# a Godot nao consegue criar user:// e a suite falha em cascata.
# -WorkRoot sobrescreve (CI, ou ambientes com escrita restrita a uma pasta).
$workRoot = if ($WorkRoot) { $WorkRoot } else {
    Join-Path ([Environment]::GetFolderPath('LocalApplicationData')) "Temp\godot-3d-specialist-tests"
}
if (Test-Path $workRoot) { Remove-Item $workRoot -Recurse -Force }
$project = Join-Path $workRoot "project"
New-Item -ItemType Directory -Force -Path $project | Out-Null
Copy-Item (Join-Path $testsRoot "project\*") $project -Recurse -Force
$env:APPDATA = Join-Path $workRoot "appdata"
New-Item -ItemType Directory -Force -Path $env:APPDATA | Out-Null

# Copia os scripts da skill para dentro do projeto de teste (fonte unica: ../scripts).
$toolsDir = Join-Path $project "scripts\tools"
New-Item -ItemType Directory -Force -Path $toolsDir | Out-Null
Get-ChildItem (Join-Path $skillRoot "scripts\*.gd") | Copy-Item -Destination $toolsDir -Force
New-Item -ItemType Directory -Force -Path (Join-Path $project "scenes") | Out-Null
Copy-Item (Join-Path $project "scenes_src\duplicate.tscn") (Join-Path $project "scenes\duplicate.tscn") -Force

$script:passed = 0
$script:failed = 0
function Report([string]$name, [bool]$ok, [string]$detail = "") {
    if ($ok) { $script:passed++; Write-Host "PASS $name $detail" }
    else { $script:failed++; Write-Host "FAIL $name $detail" }
}
function Run-Godot([string[]]$godotArgs) {
    # Timeout obrigatorio: um --script que falha ao carregar nao chama quit()
    # e a Godot headless fica viva para sempre. 120s por etapa e mata o processo.
    # System.Diagnostics.Process (nao Start-Process): ExitCode confiavel.
    $argLine = (@("--headless", "--path", $project) + $godotArgs | ForEach-Object { '"' + $_ + '"' }) -join " "
    $info = New-Object System.Diagnostics.ProcessStartInfo
    $info.FileName = $GodotPath
    $info.Arguments = $argLine
    $info.UseShellExecute = $false
    $info.RedirectStandardOutput = $true
    $info.RedirectStandardError = $true
    $info.CreateNoWindow = $true
    $proc = [System.Diagnostics.Process]::Start($info)
    $stdoutTask = $proc.StandardOutput.ReadToEndAsync()
    $stderrTask = $proc.StandardError.ReadToEndAsync()
    if (-not $proc.WaitForExit(120000)) {
        try { $proc.Kill() } catch {}
        return @{ Out = "TIMEOUT apos 120s: $argLine"; Exit = 124 }
    }
    return @{ Out = ($stdoutTask.Result + $stderrTask.Result); Exit = $proc.ExitCode }
}

Write-Host "== Godot: $(& $GodotPath --version)"

$r = Run-Godot @("--import", "--quit"); Report "import do projeto" ($r.Exit -eq 0)
$r = Run-Godot @("--script", "res://gen_fixtures.gd"); Report "geracao de fixtures" ($r.Exit -eq 0)
$r = Run-Godot @("--script", "res://test_aligner.gd")
Report "PropAligner (4 casos)" ($r.Exit -eq 0 -and $r.Out -match "ALIGNER_DONE failures=0") (($r.Out | Select-String "FAIL .*").Line -join "; ")
$r = Run-Godot @("--script", "res://test_save_system.gd")
Report "SaveSystem ida-e-volta" ($r.Exit -eq 0 -and $r.Out -match "SAVE_DONE failures=0")
$r = Run-Godot @("--script", "res://test_components.gd")
Report "componentes (StateMachine/Health)" ($r.Exit -eq 0 -and $r.Out -match "COMPONENTS_DONE failures=0") (($r.Out | Select-String "FAIL .*").Line -join "; ")
$r = Run-Godot @("--script", "res://test_csg_material.gd")
Report "CSG bake + material PBR" ($r.Exit -eq 0 -and $r.Out -match "CSG_MATERIAL_DONE failures=0") (($r.Out | Select-String "FAIL .*").Line -join "; ")
$r = Run-Godot @("--script", "res://test_recorder.gd")
Report "DevlogRecorder (nomes de frame)" ($r.Exit -eq 0 -and $r.Out -match "RECORDER_DONE failures=0")
$r = Run-Godot @("--script", "res://export_glb.gd"); Report "exportacao fixture.glb" ($r.Exit -eq 0)
$r = Run-Godot @("--import", "--quit"); Report "import do fixture.glb" ($r.Exit -eq 0)
$r = Run-Godot @("--script", "res://test_import.gd")
Report "sufixos de importacao (-col/-colonly/-occ)" ($r.Exit -eq 0 -and $r.Out -match "IMPORT_DONE failures=0") (($r.Out | Select-String "FAIL .*").Line -join "; ")

# Auditor: compara tipos e exit com o esperado.
$expected = Get-Content (Join-Path $testsRoot "expected\auditor_expected.json") -Raw | ConvertFrom-Json
foreach ($scene in $expected.PSObject.Properties.Name) {
    $r = Run-Godot @("--script", "res://scripts/tools/scene_auditor.gd", "--", "res://scenes/$scene.tscn")
    $reportPath = Join-Path $project "devlog\audit_report.json"
    $types = @()
    if (Test-Path $reportPath) {
        $types = @((Get-Content $reportPath -Raw | ConvertFrom-Json).issues | ForEach-Object { $_.type } | Sort-Object)
    }
    $want = @($expected.$scene.types | Sort-Object)
    $ok = ($r.Exit -eq $expected.$scene.exit) -and (($types -join ",") -eq ($want -join ","))
    Report "auditor/$scene" $ok "exit=$($r.Exit) types=$($types -join ',')"
}

# Multi-cena + config: ignorar NON_UNIFORM_SCALE e limitar luzes a 2.
Copy-Item (Join-Path $testsRoot "audit_config_test.json") (Join-Path $project "audit_config_test.json") -Force
$r = Run-Godot @("--script", "res://scripts/tools/scene_auditor.gd", "--", "--config=res://audit_config_test.json", "res://scenes/nonuniform.tscn", "res://scenes/many_lights.tscn")
$types = @((Get-Content (Join-Path $project "devlog\audit_report.json") -Raw | ConvertFrom-Json).issues | ForEach-Object { $_.type } | Sort-Object)
Report "auditor multi-cena+config" ($r.Exit -eq 0 -and ($types -join ",") -eq "TOO_MANY_LIGHTS") "types=$($types -join ',')"

# Devlog HTML: abre a pagina de verdade no Edge headless, se disponivel.
$edge = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
if (Test-Path $edge) {
    $r = Run-Godot @("--script", "res://scripts/tools/scene_auditor.gd", "--", "res://scenes/valid.tscn")
    $site = Join-Path $workRoot "site"
    New-Item -ItemType Directory -Force -Path $site | Out-Null
    Copy-Item (Join-Path $skillRoot "templates\devlog.html") (Join-Path $site "index.html") -Force
    Copy-Item (Join-Path $project "devlog\audit_report.json") (Join-Path $site "audit_report.json") -Force
    # --virtual-time-budget: sem ele o dump sai antes do fetch() do painel terminar.
    $dom = & $edge --headless --disable-gpu --allow-file-access-from-files --virtual-time-budget=5000 --dump-dom ("file:///" + ($site -replace "\\", "/") + "/index.html") 2>$null | Out-String
    Report "devlog HTML renderiza auditoria" ($dom -match "0 erro\(s\)") ""
} else {
    Write-Host "SKIP devlog HTML :: Edge nao encontrado"
}

Write-Host "== RESULTADO: $($script:passed) passaram, $($script:failed) falharam"
exit $(if ($script:failed -gt 0) { 1 } else { 0 })
