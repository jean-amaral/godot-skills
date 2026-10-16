#!/usr/bin/env bash
# godot-skills installer for macOS/Linux.
# Links this repo's skills into the global skill dirs of Claude Code, Codex,
# OpenCode and Antigravity, and (by default) enables daily auto-update.
#
#   ./install/install.sh                   # all agents + auto-update
#   ./install/install.sh claude codex      # subset
#   NO_AUTO_UPDATE=1 ./install/install.sh  # links only
#   ./install/install.sh --uninstall       # remove links + auto-update
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOME_DIR="${GODOT_SKILLS_HOME_OVERRIDE:-$HOME}"
UNINSTALL=0
AGENTS=()
for arg in "$@"; do
  case "$arg" in
    --uninstall) UNINSTALL=1 ;;
    *) AGENTS+=("$arg") ;;
  esac
done
if [ "${#AGENTS[@]}" -eq 0 ]; then AGENTS=(claude codex opencode antigravity); fi

agent_dirs() {
  case "$1" in
    claude)      echo "$HOME_DIR/.claude/skills" ;;
    codex)       echo "$HOME_DIR/.agents/skills $HOME_DIR/.codex/skills" ;;
    opencode)    echo "$HOME_DIR/.config/opencode/skills $HOME_DIR/.agents/skills" ;;
    antigravity) echo "$HOME_DIR/.gemini/config/skills $HOME_DIR/.gemini/antigravity/skills" ;;
    *) echo "" ;;
  esac
}

is_our_link() {
  [ -L "$1" ] && case "$(readlink "$1")" in "$REPO_ROOT"*) return 0 ;; *) return 1 ;; esac
}

if [ "$UNINSTALL" -eq 1 ]; then
  for agent in "${AGENTS[@]}"; do
    for dir in $(agent_dirs "$agent"); do
      for skill in "$REPO_ROOT"/skills/*/; do
        dest="$dir/$(basename "$skill")"
        if is_our_link "$dest"; then rm "$dest"; echo "REMOVED link $dest"; fi
      done
    done
  done
  for file in "$HOME_DIR/.claude/CLAUDE.md" "$HOME_DIR/.codex/AGENTS.md" "$HOME_DIR/.config/opencode/AGENTS.md" "$HOME_DIR/.gemini/GEMINI.md"; do
    if [ -f "$file" ] && grep -q 'godot-skills-updater:start' "$file"; then
      sed -i.bak '/<!-- godot-skills-updater:start -->/,/<!-- godot-skills-updater:end -->/d' "$file" && rm -f "$file.bak"
      echo "Update trigger removed from $file"
    fi
  done
  (crontab -l 2>/dev/null | grep -v "godot-skills-auto-update" | crontab -) || true
  rm -f "$HOME_DIR/Library/LaunchAgents/com.godot-skills.update.plist" 2>/dev/null || true
  echo "Uninstall done (repo clone and real directories were kept)."
  exit 0
fi

if [ -d "$REPO_ROOT/.git" ]; then
  git -C "$REPO_ROOT" pull --ff-only 2>/dev/null && echo "Repo updated (git pull --ff-only)." \
    || echo "WARN repo update skipped (offline or diverged). Installing current content."
fi

linked=0
for agent in "${AGENTS[@]}"; do
  dirs="$(agent_dirs "$agent")"
  if [ -z "$dirs" ]; then echo "WARN unknown agent: $agent"; continue; fi
  for dir in $dirs; do
    mkdir -p "$dir"
    for skill in "$REPO_ROOT"/skills/*/; do
      name="$(basename "$skill")"
      dest="$dir/$name"
      if [ -L "$dest" ]; then
        [ "$(readlink "$dest")" = "${skill%/}" ] && continue
        rm "$dest"
      elif [ -e "$dest" ]; then
        echo "SKIP $dest (real directory exists; remove it first to replace with a link)"
        continue
      fi
      ln -s "${skill%/}" "$dest"
      linked=$((linked + 1))
      echo "LINK $agent -> $dest"
    done
  done
done
echo "Linked $linked skill folder(s). Package version: $(cat "$REPO_ROOT/VERSION")"

# Record the clone location and install the session-start update trigger
# (a marked block in each agent's global rules file; the updater skill it
# invokes only ever checks the pinned official repo).
mkdir -p "$HOME_DIR/.godot-skills"
printf '%s\n' "$REPO_ROOT" > "$HOME_DIR/.godot-skills/clone-path.txt"

rule_file_for() {
  case "$1" in
    claude)      echo "$HOME_DIR/.claude/CLAUDE.md" ;;
    codex)       echo "$HOME_DIR/.codex/AGENTS.md" ;;
    opencode)    echo "$HOME_DIR/.config/opencode/AGENTS.md" ;;
    antigravity) echo "$HOME_DIR/.gemini/GEMINI.md" ;;
  esac
}
for agent in "${AGENTS[@]}"; do
  file="$(rule_file_for "$agent")"
  [ -z "$file" ] && continue
  mkdir -p "$(dirname "$file")"
  if [ -f "$file" ] && grep -q 'godot-skills-updater:start' "$file"; then
    echo "Trigger already present in $file"; continue
  fi
  cat >> "$file" <<'BLOCK'

<!-- godot-skills-updater:start -->
## godot-skills: verificacao de atualizacao (fazer uma vez por sessao)
Na primeira tarefa da sessao, carregue a skill godot-skills-updater e siga o protocolo dela: verificar (no maximo 1x/hora) se ha atualizacao SOMENTE no repositorio oficial jean-amaral/godot-skills, avisar o criador mostrando o que mudou e atualizar apenas com confirmacao explicita. Nunca verifique nem baixe skills de outra fonte por esta regra. Se a skill nao estiver instalada neste agente, ignore esta regra em silencio.
<!-- godot-skills-updater:end -->
BLOCK
  echo "Update trigger added to $file"
done

if [ "${NO_AUTO_UPDATE:-0}" != "1" ]; then
  updater="$REPO_ROOT/install/update.sh"
  chmod +x "$updater" 2>/dev/null || true
  if [ "$(uname)" = "Darwin" ]; then
    plist="$HOME_DIR/Library/LaunchAgents/com.godot-skills.update.plist"
    mkdir -p "$(dirname "$plist")"
    cat > "$plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>Label</key><string>com.godot-skills.update</string>
  <key>ProgramArguments</key><array><string>$updater</string></array>
  <key>StartInterval</key><integer>14400</integer>
</dict></plist>
PLIST
    launchctl load "$plist" 2>/dev/null || true
    echo "Auto-update ON: LaunchAgent every 4h (git pull; links are live)."
  else
    (crontab -l 2>/dev/null | grep -v "godot-skills-auto-update"; \
      echo "0 */4 * * * $updater # godot-skills-auto-update") | crontab -
    echo "Auto-update ON: cron every 4h (git pull; links are live)."
  fi
else
  echo "Auto-update OFF (NO_AUTO_UPDATE=1). Manual update: install/update.sh"
fi
echo "Restart your agents to pick up the skills."
