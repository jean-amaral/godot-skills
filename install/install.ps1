# godot-skills installer for Windows (PowerShell 5.1+). ASCII only on purpose.
# Links this repo's skills into the global skill dirs of Claude Code, Codex,
# OpenCode and Antigravity, and (by default) registers a daily auto-update.
#
#   .\install\install.ps1                      # all agents + auto-update
#   .\install\install.ps1 -Agents claude,codex # subset
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
if ($Agents -contains "all") { $Agents = @("claude", "codex", "opencode", "antigravity") }

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
                if (Test-Path $dest) { Remove-SkillLink $dest | Out-Null }
            }
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

if (-not $NoAutoUpdate) {
    try {
        $updater = Join-Path $RepoRoot "install\update.ps1"
        $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$updater`""
        $repeat = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(5) -RepetitionInterval (New-TimeSpan -Hours 4) -RepetitionDuration (New-TimeSpan -Days 3650)
        $settings = New-ScheduledTaskSettingsSet -StartWhenAvailable
        Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $repeat -Settings $settings -Force | Out-Null
        try {
            $logon = New-ScheduledTaskTrigger -AtLogOn
            Register-ScheduledTask -TaskName ($TaskName + "-logon") -Action $action -Trigger $logon -Settings $settings -Force | Out-Null
        } catch { Write-Host "WARN logon trigger not registered: $($_.Exception.Message)" }        Write-Host "Auto-update ON: tasks '$TaskName' (every 4h) and '$TaskName-logon' (git pull; links are live)."
    } catch {
        Write-Host "WARN could not register the scheduled task: $($_.Exception.Message)"
        Write-Host "Auto-update stays manual: run install\update.ps1 any time."
    }
} else {
    Write-Host "Auto-update OFF (-NoAutoUpdate). Manual update: install\update.ps1"
}
Write-Host "Restart your agents to pick up the skills."
