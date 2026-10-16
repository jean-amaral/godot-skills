# godot-skills updater (Windows). Links are junctions into this clone,
# so a git pull is all an update needs. Safe to run any time / from scheduler.
$ErrorActionPreference = "Continue"
$RepoRoot = Split-Path $PSScriptRoot -Parent
git -C $RepoRoot pull --ff-only
$version = Get-Content (Join-Path $RepoRoot "VERSION") -ErrorAction SilentlyContinue
Write-Host "godot-skills is now at $version (skills update in place via links)."
