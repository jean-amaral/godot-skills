#!/usr/bin/env bash
# godot-skills updater (macOS/Linux). Links are symlinks into this clone,
# so a git pull is all an update needs. Safe to run any time / from scheduler.
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
git -C "$REPO_ROOT" pull --ff-only
echo "godot-skills is now at $(cat "$REPO_ROOT/VERSION") (skills update in place via links)."
