#!/usr/bin/env bash
# godot-skills updater (macOS/Linux). Links are symlinks into this clone,
# so a git pull is all an update needs for most agents. Exception:
# Antigravity CLI does not follow symlinks, so its skills are real
# copies that this script refreshes after the pull.
# Safe to run any time / from scheduler.
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOME_DIR="${GODOT_SKILLS_HOME_OVERRIDE:-$HOME}"
git -C "$REPO_ROOT" pull --ff-only
echo "$(date "+%Y-%m-%d %H:%M:%S") updated to $(cat "$REPO_ROOT/VERSION")" >> "$REPO_ROOT/update.log"
echo "godot-skills is now at $(cat "$REPO_ROOT/VERSION") (skills update in place via links)."

agents_file="$HOME_DIR/.godot-skills/agents.txt"
if [ -f "$agents_file" ] && grep -qx "antigravity" "$agents_file"; then
  for dir in "$HOME_DIR/.gemini/config/skills" "$HOME_DIR/.gemini/antigravity/skills"; do
    mkdir -p "$dir"
    for skill in "$REPO_ROOT"/skills/*/; do
      name="$(basename "$skill")"
      dest="$dir/$name"
      if [ -L "$dest" ]; then rm "$dest";
      elif [ -e "$dest" ] && [ ! -f "$dest/.godot-skills-copy" ]; then
        echo "SKIP $dest (real directory not managed by godot-skills)"; continue
      fi
      rm -rf "$dest"
      cp -R "${skill%/}" "$dest"
      printf '%s\n' "$REPO_ROOT" > "$dest/.godot-skills-copy"
    done
  done
  echo "Antigravity real copies refreshed (its CLI does not follow links)."
fi
