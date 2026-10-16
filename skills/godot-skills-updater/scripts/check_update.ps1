# godot-skills update checker (Windows). ASCII only (PowerShell 5.1).
# The ONLY repository this script will ever fetch from is pinned below.
# There is intentionally no -Url / -Repo parameter.
# Exit codes: 0 ok/skipped/updated, 10 update available, 20 refused, 21 offline.
param(
    [string]$CloneDir = "",
    [switch]$Apply,
    [switch]$Force
)
$ErrorActionPreference = "Continue"
$PinnedRepo = "jean-amaral/godot-skills"
$PinnedUrl  = "https://github.com/jean-amaral/godot-skills.git"
$MarkerDir  = Join-Path $HOME ".godot-skills"

function Out-Status([string]$status, [hashtable]$extra) {
    Write-Host "STATUS=$status"
    if ($extra) { foreach ($k in $extra.Keys) { Write-Host "$k=$($extra[$k])" } }
}

function Normalize-Repo([string]$url) {
    if (-not $url) { return "" }
    $u = $url.Trim().ToLower()
    $u = $u -replace '^https?://github\.com/', ''
    $u = $u -replace '^ssh://git@github\.com/', ''
    $u = $u -replace '^git@github\.com:', ''
    $u = $u -replace '\.git$', ''
    $u = $u.TrimEnd('/')
    return $u
}

# --- locate the clone (recorded by the installer) -------------------------
if (-not $CloneDir -and $env:GODOT_SKILLS_HOME) { $CloneDir = $env:GODOT_SKILLS_HOME }
if (-not $CloneDir) {
    $marker = Join-Path $MarkerDir "clone-path.txt"
    if (Test-Path $marker) { $CloneDir = (Get-Content $marker -ErrorAction SilentlyContinue | Select-Object -First 1).Trim() }
}
if (-not $CloneDir) {
    foreach ($cand in @((Join-Path $HOME "godot-skills"))) { if (Test-Path (Join-Path $cand ".git")) { $CloneDir = $cand; break } }
}
if (-not $CloneDir -or -not (Test-Path (Join-Path $CloneDir ".git"))) {
    Out-Status "REFUSED_WRONG_REPO" @{ REASON = "clone not found (run install\install.ps1 first)" }; exit 20
}
$CloneDir = [System.IO.Path]::GetFullPath($CloneDir)

# --- identity check BEFORE any network access -----------------------------
$top = (git -C $CloneDir rev-parse --show-toplevel 2>$null)
if (-not $top -or ([System.IO.Path]::GetFullPath($top.Trim()) -ne $CloneDir)) {
    Out-Status "REFUSED_WRONG_REPO" @{ REASON = "git toplevel mismatch" }; exit 20
}
$remote = Normalize-Repo (git -C $CloneDir remote get-url origin 2>$null)
if ($remote -ne $PinnedRepo) {
    Out-Status "REFUSED_WRONG_REPO" @{ REASON = "origin is '$remote', expected '$PinnedRepo'" }; exit 20
}
foreach ($identity in @("VERSION", "skills\godot-3d-specialist\SKILL.md")) {
    if (-not (Test-Path (Join-Path $CloneDir $identity))) {
        Out-Status "REFUSED_WRONG_REPO" @{ REASON = "identity file missing: $identity" }; exit 20
    }
}

# --- throttle: at most one check per hour ---------------------------------
$stampFile = Join-Path $MarkerDir "last-check.txt"
if (-not $Apply -and -not $Force -and (Test-Path $stampFile)) {
    try {
        $last = [DateTime]::Parse((Get-Content $stampFile | Select-Object -First 1))
        if (((Get-Date) - $last).TotalMinutes -lt 60) { Out-Status "SKIPPED_THROTTLE" @{}; exit 0 }
    } catch {}
}

# --- fetch from the pinned URL only ---------------------------------------
git -C $CloneDir fetch --no-tags $PinnedUrl main 2>$null | Out-Null
if ($LASTEXITCODE -ne 0) { Out-Status "OFFLINE" @{ REASON = "git fetch failed" }; exit 21 }
New-Item -ItemType Directory -Force -Path $MarkerDir | Out-Null
(Get-Date).ToString("o") | Set-Content $stampFile

$fetchHeadOk = $true
git -C $CloneDir cat-file -e "FETCH_HEAD:VERSION" 2>$null; if ($LASTEXITCODE -ne 0) { $fetchHeadOk = $false }
git -C $CloneDir cat-file -e "FETCH_HEAD:skills/godot-3d-specialist/SKILL.md" 2>$null; if ($LASTEXITCODE -ne 0) { $fetchHeadOk = $false }
if (-not $fetchHeadOk) { Out-Status "REFUSED_WRONG_REPO" @{ REASON = "fetched tree lacks identity files" }; exit 20 }

$head = (git -C $CloneDir rev-parse HEAD).Trim()
$remoteHead = (git -C $CloneDir rev-parse FETCH_HEAD).Trim()
$localVersion = (Get-Content (Join-Path $CloneDir "VERSION") | Select-Object -First 1).Trim()
$remoteVersion = (git -C $CloneDir show "FETCH_HEAD:VERSION").Trim()

if ($head -eq $remoteHead) { Out-Status "UP_TO_DATE" @{ VERSION = $localVersion }; exit 0 }

git -C $CloneDir merge-base --is-ancestor HEAD FETCH_HEAD 2>$null
if ($LASTEXITCODE -ne 0) {
    Out-Status "REFUSED_NOT_FAST_FORWARD" @{ LOCAL = $localVersion; REMOTE = $remoteVersion }; exit 20
}
if (-not $Apply) {
    $changes = (git -C $CloneDir log --oneline "HEAD..FETCH_HEAD") -join " | "
    Out-Status "UPDATE_AVAILABLE" @{ LOCAL = $localVersion; REMOTE = $remoteVersion; CHANGES = $changes }
    exit 10
}

# --- apply: clean tree required, fast-forward only ------------------------
$dirty = git -C $CloneDir status --porcelain
if ($dirty) { Out-Status "REFUSED_DIRTY_TREE" @{ REASON = "local changes in the skills clone" }; exit 20 }
git -C $CloneDir merge --ff-only FETCH_HEAD 2>$null | Out-Null
if ($LASTEXITCODE -ne 0) { Out-Status "REFUSED_NOT_FAST_FORWARD" @{}; exit 20 }
# Refresh Antigravity real copies via the repo updater (best effort).
$upd = Join-Path $CloneDir "install\update.ps1"
if (Test-Path $upd) { try { & $upd | Out-Null } catch {} }
$newVersion = (Get-Content (Join-Path $CloneDir "VERSION") | Select-Object -First 1).Trim()
Add-Content (Join-Path $CloneDir "update.log") "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')) updated via updater skill to $newVersion"
Out-Status "UPDATED" @{ FROM = $localVersion; TO = $newVersion }
exit 0
