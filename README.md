# godot-skills

Pacote de skills Godot para agentes de código (Antigravity, OpenCode, Codex e
Claude): desenvolvimento 3D com padrão de qualidade alto, assets gratuitos
com licença verificada, criação visual e áudio/cinematografia — sempre com
pesquisa e referências antes de construir.

**Versão do pacote: `v1.0.2-10.2026`** (ver [VERSION](VERSION) e [releases](#versões))

## Skills incluídas

| Skill | Para quê |
|---|---|
| `godot-3d-specialist` | Jogo 3D na Godot 4.7+: concepção por entrevista, planejamento, CSG→bake, props modulares realistas, auditoria headless, save/load e devlog |
| `godot-free-assets` | Buscar e baixar assets **100% gratuitos (só CC0/CC-BY)** compatíveis com o projeto, com crédito e checksum |
| `godot-visual-craft` | Shaders realistas, materiais PBR avançados e animação com peso |
| `godot-audio-cinematics` | Direção de áudio, cutscenes com pulo seguro e gramática de câmera |

## Instalação global (uma vez)

Clone e rode o instalador do seu sistema. Ele **linka** (não copia) as
skills para os diretórios globais de cada agente, então uma atualização do
repositório aparece em todos ao mesmo tempo.

Windows (PowerShell):

```powershell
git clone https://github.com/jean-amaral/godot-skills.git
cd godot-skills
.\install\install.ps1
```

macOS/Linux:

```bash
git clone https://github.com/jean-amaral/godot-skills.git
cd godot-skills
chmod +x install/*.sh
./install/install.sh
```

Reinicie os agentes depois de instalar para eles descobrirem as skills.

### Onde cada agente recebe as skills

| Agente | Diretório(s) global(is) |
|---|---|
| Claude Code | `~/.claude/skills/` |
| Codex | `~/.agents/skills/` (pessoal, atual) e `~/.codex/skills/` (compatível) |
| OpenCode | `~/.config/opencode/skills/` e `~/.agents/skills/` (compatível) |
| Antigravity | `~/.gemini/config/skills/` e `~/.gemini/antigravity/skills/` |

Instalação parcial: `.\install\install.ps1 -Agents claude,codex` ou
`./install/install.sh claude codex`. Um diretório real já existente no
destino **nunca** é apagado sem `-Force`: o instalador pula e avisa.

## Atualização automática

O instalador registra, por padrão, uma atualização no login, a cada 4 horas e diária às 10:00
(Tarefa Agendada no Windows, cron no Linux, LaunchAgent no macOS) que roda
`git pull --ff-only` neste clone. Como cada agente lê as skills por link
(junction/symlink) para dentro do clone, **atualizou o clone, atualizou
todos os agentes** — sem copiar nada.

- Desligar na instalação: `-NoAutoUpdate` (Windows) ou `NO_AUTO_UPDATE=1` (macOS/Linux).
- Atualizar na hora: `install\update.ps1` ou `install/update.sh`.
- Desinstalar links e a tarefa: `.\install\install.ps1 -Uninstall` ou `./install/install.sh --uninstall` (o clone e diretórios reais seus ficam intactos).

> A atualização automática depende do agendador do sistema operacional
> estar ativo (tarefa/cron/launchd habilitado). Sem ele, a atualização é o
> `update` manual acima — um comando.

## Versões

- **Pacote** (este repo, tags `vX.Y.Z-MM.AAAA`): `v1.0.0-10.2026` é a
  primeira distribuição pública das quatro skills; `v1.0.1-10.2026`/`v1.0.2-10.2026` reforçam a atualização automática (login + a cada 4h, duas tarefas no Windows, + log em `update.log`). Conteúdo validado
  na Godot 4.7.2 (suítes de teste dentro de cada skill, em `tests/`).
- Cada skill mantém seu histórico interno no próprio `CHANGELOG.md`.

## Desenvolvimento

As suítes ficam dentro de cada skill (`skills/<skill>/tests/run_tests.ps1`,
requerem uma Godot 4.7+ via `GODOT_PATH`). Rode-as antes de publicar
mudança em `scripts/` ou `shaders/` de qualquer skill.
