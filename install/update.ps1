# godot-skills updater (Windows). Links are junctions into this clone,
# so a git pull is all an update needs for most agents. Exception:
# Antigravity CLI does not follow junctions, so its skills are real
# copies that this script refreshes after the pull.
# Safe to run any time / from scheduler.
$ErrorActionPreference = "Continue"
$RepoRoot = Split-Path $PSScriptRoot -Parent
$HomeDir = if ($env:GODOT_SKILLS_HOME_OVERRIDE) { $env:GODOT_SKILLS_HOME_OVERRIDE } else { $HOME }
git -C $RepoRoot pull --ff-only
$version = Get-Content (Join-Path $RepoRoot "VERSION") -ErrorAction SilentlyContinue
$stamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Add-Content (Join-Path $RepoRoot "update.log") "$stamp updated to $version"
Write-Host "godot-skills is now at $version (skills update in place via links)."

$agentsFile = Join-Path $HomeDir ".godot-skills\agents.txt"
if ((Test-Path $agentsFile) -and ((Get-Content $agentsFile) -contains "antigravity")) {
    foreach ($dir in @("$HomeDir\.gemini\config\skills", "$HomeDir\.gemini\antigravity\skills")) {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
        foreach ($skill in (Get-ChildItem (Join-Path $RepoRoot "skills") -Directory)) {
            $dest = Join-Path $dir $skill.Name
            $copyMarker = Join-Path $dest ".godot-skills-copy"
            $item = Get-Item $dest -Force -ErrorAction SilentlyContinue
            if ($item -and $item.LinkType) {
                [System.IO.Directory]::Delete($dest)
            } elseif ((Test-Path $dest) -and -not (Test-Path $copyMarker)) {
                Write-Host "SKIP $dest (real directory not managed by godot-skills)"
                continue
            }
            if (Test-Path $dest) { Remove-Item $dest -Recurse -Force }
            Copy-Item $skill.FullName $dest -Recurse -Force
            Set-Content -Path $copyMarker -Value $RepoRoot -Encoding ASCII
        }
    }
    Write-Host "Antigravity real copies refreshed (its CLI does not follow links)."
}
