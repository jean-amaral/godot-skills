# godot-skills installer for Windows (PowerShell 5.1+). ASCII only on purpose.
# Links this repo's skills into the global skill dirs of Claude Code, Codex,
# OpenCode and Antigravity, and (by default) registers a daily auto-update.
#
#   .\install\install.ps1                      # asks which agents (menu)
#   .\install\install.ps1 -Agents claude,codex # subset, no menu
#   .\install\install.ps1 -NoAutoUpdate        # links only
#   .\install\install.ps1 -Uninstall           # remove links + update task
param(
    [string[]]$Agents = @("all"),
    [switch]$NoAutoUpdate,
    [switch]$Uninstall,
    [switch]$Force
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path $PSScriptRoot -Parent
$HomeDir = if ($env:GODOT_SKILLS_HOME_OVERRIDE) { $env:GODOT_SKILLS_HOME_OVERRIDE } else { $HOME }
$TaskName = "godot-skills-auto-update"

$agentDirs = @{
    "claude"      = @("$HomeDir\.claude\skills")
    "codex"       = @("$HomeDir\.agents\skills", "$HomeDir\.codex\skills")
    "opencode"    = @("$HomeDir\.config\opencode\skills", "$HomeDir\.agents\skills")
    "antigravity" = @("$HomeDir\.gemini\config\skills", "$HomeDir\.gemini\antigravity\skills")
}
# Interactive choice: with no explicit -Agents on an interactive console,
# the user picks 1-4 (comma-separated, e.g. "1,3"), 5 or Enter for all.
# Redirected/non-interactive input keeps the safe default: all agents.
$explicitAgents = $PSBoundParameters.ContainsKey("Agents")
if (-not $explicitAgents -and -not $Uninstall -and -not [Console]::IsInputRedirected) {
    $menu = @{ "1" = "claude"; "2" = "codex"; "3" = "opencode"; "4" = "antigravity" }
    while ($true) {
        Write-Host ""
        Write-Host "Install godot-skills for which agents?"
        Write-Host "  1) Claude Code"
        Write-Host "  2) Codex"
        Write-Host "  3) OpenCode"
        Write-Host "  4) Antigravity"
        Write-Host "  5) All of them"
        $choice = (Read-Host "Choose 1-4 (comma-separated, e.g. 1,3), 5 or Enter for all").Trim().ToLower()
        if ($choice -eq "" -or $choice -eq "5" -or $choice -eq "all" -or $choice -eq "todos") {
            $Agents = @("claude", "codex", "opencode", "antigravity"); break
        }
        $picked = @()
        $valid = $true
        foreach ($part in ($choice -split ",")) {
            $key = $part.Trim()
            if ($menu.ContainsKey($key)) { if ($picked -notcontains $menu[$key]) { $picked += $menu[$key] } }
            else { $valid = $false }
        }
        if ($valid -and $picked.Count -gt 0) { $Agents = $picked; break }
        Write-Host "Invalid choice. Examples: 1  |  2,4  |  5"
    }
}
if ($Agents -contains "all") { $Agents = @("claude", "codex", "opencode", "antigravity") }
Write-Host "Selected agents: $($Agents -join ', ')"

$skillDirs = Get-ChildItem (Join-Path $RepoRoot "skills") -Directory
if (-not $skillDirs) { throw "No skills found under $RepoRoot\skills" }

function Get-LinkTarget([string]$path) {
    $item = Get-Item $path -Force -ErrorAction SilentlyContinue
    if ($item -and $item.LinkType) { return [string]$item.Target }
    return $null
}

function Remove-LinkOnly([string]$path) {
    # Remove-Item on a junction throws NullReference in Windows PowerShell 5.1.
    # Directory.Delete on a junction removes the link, never the target.
    [System.IO.Directory]::Delete($path)
}

function Remove-SkillLink([string]$dest) {
    $target = Get-LinkTarget $dest
    if ($target -and $target.StartsWith($RepoRoot)) {
        Remove-LinkOnly $dest
        Write-Host "REMOVED link $dest"
        return $true
    }
    return $false
}

if ($Uninstall) {
    foreach ($agent in $Agents) {
        foreach ($dir in $agentDirs[$agent]) {
            foreach ($skill in $skillDirs) {
                $dest = Join-Path $dir $skill.Name
if (Test-Path $dest) {
                    Remove-SkillLink $dest | Out-Null
                    $copyMarker = Join-Path $dest ".godot-skills-copy"
                    if ((Test-Path $copyMarker) -and -not (Get-LinkTarget $dest)) {
                        Remove-Item $dest -Recurse -Force
                        Write-Host "REMOVED copy $dest"
                    }
                }
            }
        }
    }
    foreach ($file in @("$HomeDir\.claude\CLAUDE.md", "$HomeDir\.codex\AGENTS.md", "$HomeDir\.config\opencode\AGENTS.md", "$HomeDir\.gemini\GEMINI.md")) {
        if (Test-Path $file) {
            $txt = Get-Content $file -Raw
            $clean = [regex]::Replace($txt, '(?s)\s*<!-- godot-skills-updater:start -->.*?<!-- godot-skills-updater:end -->', '')
            if ($clean -ne $txt) { Set-Content -Path $file -Value $clean -Encoding UTF8; Write-Host "Update trigger removed from $file" }
        }
    }
    try { Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue; Unregister-ScheduledTask -TaskName ($TaskName + "-logon") -Confirm:$false -ErrorAction SilentlyContinue } catch {}
    Write-Host "Uninstall done (repo clone and real directories were kept)."
    exit 0
}

# Fresh content first: the links below are live views of this clone.
if (Test-Path (Join-Path $RepoRoot ".git")) {
    try { git -C $RepoRoot pull --ff-only 2>$null | Out-Null; Write-Host "Repo updated (git pull --ff-only)." }
    catch { Write-Host "WARN repo update skipped (offline or diverged). Installing current content." }
}

$linked = 0
foreach ($agent in $Agents) {
    if (-not $agentDirs.ContainsKey($agent)) { Write-Host "WARN unknown agent: $agent"; continue }
    foreach ($dir in $agentDirs[$agent]) {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
        foreach ($skill in $skillDirs) {
            $dest = Join-Path $dir $skill.Name
            $src = $skill.FullName
            if ($agent -eq "antigravity") {
                # Antigravity CLI does not follow junctions/symlinks when
                # discovering skills (verified on agy): use real copies,
                # refreshed by install/update.ps1 after every pull.
                $copyMarker = Join-Path $dest ".godot-skills-copy"
                if (Get-LinkTarget $dest) { Remove-LinkOnly $dest }
                elseif (Test-Path $dest) {
                    if (Test-Path $copyMarker) { Remove-Item $dest -Recurse -Force }
                    elseif (-not $Force) { Write-Host "SKIP $dest (real directory exists; use -Force to replace it with a managed copy)"; continue }
                    else { Remove-Item $dest -Recurse -Force }
                }
                Copy-Item $src $dest -Recurse -Force
                Set-Content -Path $copyMarker -Value $RepoRoot -Encoding ASCII
                $linked++
                Write-Host "COPY $agent -> $dest (real copy: Antigravity does not follow links)"
                continue
            }
            $existing = Get-LinkTarget $dest
            if ($existing) {
                if ($existing -eq $src) { continue }
                Remove-LinkOnly $dest
            } elseif (Test-Path $dest) {
                if (-not $Force) {
                    Write-Host "SKIP $dest (real directory exists; use -Force to replace it with a link)"
                    continue
                }
                Remove-Item $dest -Recurse -Force
            }
            New-Item -ItemType Junction -Path $dest -Target $src | Out-Null
            $linked++
            Write-Host "LINK $agent -> $dest"
        }
    }
}
Write-Host "Linked $linked skill folder(s). Package version: $(Get-Content (Join-Path $RepoRoot 'VERSION'))"

# Record the clone location and install the session-start update trigger
# (a marked block in each agent's global rules file; the updater skill it
# invokes only ever checks the pinned official repo).
$markerDir = Join-Path $HomeDir ".godot-skills"
New-Item -ItemType Directory -Force -Path $markerDir | Out-Null
Set-Content -Path (Join-Path $markerDir "clone-path.txt") -Value $RepoRoot -Encoding ASCII
Set-Content -Path (Join-Path $markerDir "agents.txt") -Value $Agents -Encoding ASCII

$ruleFiles = @{
    "claude"      = "$HomeDir\.claude\CLAUDE.md"
    "codex"       = "$HomeDir\.codex\AGENTS.md"
    "opencode"    = "$HomeDir\.config\opencode\AGENTS.md"
    "antigravity" = "$HomeDir\.gemini\GEMINI.md"
}
$ruleBlock = @'

<!-- godot-skills-updater:start -->
## godot-skills: verificacao de atualizacao (fazer uma vez por sessao)
Na primeira tarefa da sessao, carregue a skill godot-skills-updater e siga o protocolo dela: verificar (no maximo 1x/hora) se ha atualizacao SOMENTE no repositorio oficial jean-amaral/godot-skills, avisar o criador mostrando o que mudou e atualizar apenas com confirmacao explicita. Nunca verifique nem baixe skills de outra fonte por esta regra. Se a skill nao estiver instalada neste agente, ignore esta regra em silencio.
<!-- godot-skills-updater:end -->
'@
foreach ($agent in $Agents) {
    if (-not $ruleFiles.ContainsKey($agent)) { continue }
    $file = $ruleFiles[$agent]
    New-Item -ItemType Directory -Force -Path (Split-Path $file -Parent) | Out-Null
    $existing = if (Test-Path $file) { Get-Content $file -Raw } else { "" }
    if ($existing -match 'godot-skills-updater:start') { Write-Host "Trigger already present in $file"; continue }
    Add-Content -Path $file -Value $ruleBlock -Encoding UTF8
    Write-Host "Update trigger added to $file"
}

if (-not $NoAutoUpdate) {
    try {
        $updater = Join-Path $RepoRoot "install\update.ps1"
        $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$updater`""
        $repeat = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(5) -RepetitionInterval (New-TimeSpan -Hours 4) -RepetitionDuration (New-TimeSpan -Days 3650)
        $settings = New-ScheduledTaskSettingsSet -StartWhenAvailable
        Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $repeat -Settings $settings -Force | Out-Null
        $logonOk = $false
        try {
            $logon = New-ScheduledTaskTrigger -AtLogOn -User "$env:USERDOMAIN\$env:USERNAME"
            Register-ScheduledTask -TaskName ($TaskName + "-logon") -Action $action -Trigger $logon -Settings $settings -Force -ErrorAction Stop | Out-Null
            $logonOk = [bool](Get-ScheduledTask -TaskName ($TaskName + "-logon") -ErrorAction SilentlyContinue)
        } catch {
            Write-Host "WARN logon trigger not registered (access denied by Windows). The every-4h task still keeps the skills updated."
        }
        if ($logonOk) {
            Write-Host "Auto-update ON: tasks '$TaskName' (every 4h) and '$TaskName-logon' (git pull; links are live)."
        } else {
            Write-Host "Auto-update ON: task '$TaskName' every 4h (git pull; links are live). Logon trigger not registered."
        }
    } catch {
        Write-Host "WARN could not register the scheduled task: $($_.Exception.Message)"
        Write-Host "Auto-update stays manual: run install\update.ps1 any time."
    }
} else {
    Write-Host "Auto-update OFF (-NoAutoUpdate). Manual update: install\update.ps1"
}
Write-Host "Restart your agents to pick up the skills."
