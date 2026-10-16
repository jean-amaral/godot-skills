#!/usr/bin/env bash
# godot-skills update checker (macOS/Linux).
# The ONLY repository this script will ever fetch from is pinned below.
# There is intentionally no URL/repo argument.
# Exit codes: 0 ok/skipped/updated, 10 update available, 20 refused, 21 offline.
set -uo pipefail

PINNED_REPO="jean-amaral/godot-skills"
PINNED_URL="https://github.com/jean-amaral/godot-skills.git"
MARKER_DIR="$HOME/.godot-skills"
CLONE_DIR="${GODOT_SKILLS_HOME:-}"
APPLY=0; FORCE=0
for arg in "$@"; do
  case "$arg" in
    --apply) APPLY=1 ;;
    --force) FORCE=1 ;;
    --clone=*) CLONE_DIR="${arg#--clone=}" ;;
  esac
done

normalize_repo() {
  local u
  u="$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')"
  u="${u#https://github.com/}"; u="${u#http://github.com/}"
  u="${u#ssh://git@github.com/}"; u="${u#git@github.com:}"
  u="${u%.git}"; u="${u%/}"
  printf '%s' "$u"
}

# --- locate the clone (recorded by the installer) ---
if [ -z "$CLONE_DIR" ] && [ -f "$MARKER_DIR/clone-path.txt" ]; then
  CLONE_DIR="$(head -n1 "$MARKER_DIR/clone-path.txt" | tr -d '[:space:]')"
fi
if [ -z "$CLONE_DIR" ] && [ -d "$HOME/godot-skills/.git" ]; then CLONE_DIR="$HOME/godot-skills"; fi
if [ -z "$CLONE_DIR" ] || [ ! -d "$CLONE_DIR/.git" ]; then
  echo "STATUS=REFUSED_WRONG_REPO"; echo "REASON=clone not found (run install/install.sh first)"; exit 20
fi
CLONE_DIR="$(cd "$CLONE_DIR" && pwd)"

# --- identity check BEFORE any network access ---
top="$(git -C "$CLONE_DIR" rev-parse --show-toplevel 2>/dev/null || true)"
if [ -z "$top" ] || [ "$(cd "$top" 2>/dev/null && pwd)" != "$CLONE_DIR" ]; then
  echo "STATUS=REFUSED_WRONG_REPO"; echo "REASON=git toplevel mismatch"; exit 20
fi
remote="$(normalize_repo "$(git -C "$CLONE_DIR" remote get-url origin 2>/dev/null || true)")"
if [ "$remote" != "$PINNED_REPO" ]; then
  echo "STATUS=REFUSED_WRONG_REPO"; echo "REASON=origin is '$remote', expected '$PINNED_REPO'"; exit 20
fi
for identity in VERSION skills/godot-3d-specialist/SKILL.md; do
  if [ ! -f "$CLONE_DIR/$identity" ]; then
    echo "STATUS=REFUSED_WRONG_REPO"; echo "REASON=identity file missing: $identity"; exit 20
  fi
done

# --- throttle: at most one check per hour ---
stamp_file="$MARKER_DIR/last-check.txt"
if [ "$APPLY" -eq 0 ] && [ "$FORCE" -eq 0 ] && [ -f "$stamp_file" ]; then
  last_epoch="$(date -d "$(cat "$stamp_file")" +%s 2>/dev/null || date -j -f '%Y-%m-%dT%H:%M:%S' "$(cat "$stamp_file")" +%s 2>/dev/null || echo 0)"
  now_epoch="$(date +%s)"
  if [ $((now_epoch - last_epoch)) -lt 3600 ]; then echo "STATUS=SKIPPED_THROTTLE"; exit 0; fi
fi

# --- fetch from the pinned URL only ---
if ! git -C "$CLONE_DIR" fetch --no-tags "$PINNED_URL" main 2>/dev/null; then
  echo "STATUS=OFFLINE"; echo "REASON=git fetch failed"; exit 21
fi
mkdir -p "$MARKER_DIR"; date '+%Y-%m-%dT%H:%M:%S' > "$stamp_file"

if ! git -C "$CLONE_DIR" cat-file -e 'FETCH_HEAD:VERSION' 2>/dev/null \
   || ! git -C "$CLONE_DIR" cat-file -e 'FETCH_HEAD:skills/godot-3d-specialist/SKILL.md' 2>/dev/null; then
  echo "STATUS=REFUSED_WRONG_REPO"; echo "REASON=fetched tree lacks identity files"; exit 20
fi

head_sha="$(git -C "$CLONE_DIR" rev-parse HEAD)"
remote_sha="$(git -C "$CLONE_DIR" rev-parse FETCH_HEAD)"
local_version="$(head -n1 "$CLONE_DIR/VERSION" | tr -d '[:space:]')"
remote_version="$(git -C "$CLONE_DIR" show 'FETCH_HEAD:VERSION' | head -n1 | tr -d '[:space:]')"

if [ "$head_sha" = "$remote_sha" ]; then echo "STATUS=UP_TO_DATE"; echo "VERSION=$local_version"; exit 0; fi
if ! git -C "$CLONE_DIR" merge-base --is-ancestor HEAD FETCH_HEAD 2>/dev/null; then
  echo "STATUS=REFUSED_NOT_FAST_FORWARD"; echo "LOCAL=$local_version"; echo "REMOTE=$remote_version"; exit 20
fi
if [ "$APPLY" -eq 0 ]; then
  changes="$(git -C "$CLONE_DIR" log --oneline 'HEAD..FETCH_HEAD' | paste -sd' | ' -)"
  echo "STATUS=UPDATE_AVAILABLE"; echo "LOCAL=$local_version"; echo "REMOTE=$remote_version"; echo "CHANGES=$changes"
  exit 10
fi

# --- apply: clean tree required, fast-forward only ---
if [ -n "$(git -C "$CLONE_DIR" status --porcelain)" ]; then
  echo "STATUS=REFUSED_DIRTY_TREE"; echo "REASON=local changes in the skills clone"; exit 20
fi
if ! git -C "$CLONE_DIR" merge --ff-only FETCH_HEAD 2>/dev/null; then
  echo "STATUS=REFUSED_NOT_FAST_FORWARD"; exit 20
fi
# Refresh Antigravity real copies via the repo updater (best effort).
bash "$CLONE_DIR/install/update.sh" >/dev/null 2>&1 || true
new_version="$(head -n1 "$CLONE_DIR/VERSION" | tr -d '[:space:]')"
echo "$(date '+%Y-%m-%d %H:%M:%S') updated via updater skill to $new_version" >> "$CLONE_DIR/update.log"
echo "STATUS=UPDATED"; echo "FROM=$local_version"; echo "TO=$new_version"
exit 0
