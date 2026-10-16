# godot-skills

Pacote de skills Godot para agentes de código (Antigravity, OpenCode, Codex e
Claude): desenvolvimento 3D com padrão de qualidade alto, assets gratuitos
com licença verificada, criação visual e áudio/cinematografia — sempre com
pesquisa e referências antes de construir.

**Versão do pacote: `v1.0.1-10.2026`** (ver [VERSION](VERSION) e [releases](#versões))

## Skills incluídas

| Skill | Para quê |
|---|---|
| `godot-3d-specialist` | Jogo 3D na Godot 4.7+: concepção por entrevista, planejamento, CSG→bake, props modulares realistas, auditoria headless, save/load e devlog |
| `godot-free-assets` | Buscar e baixar assets **100% gratuitos (só CC0/CC-BY)** compatíveis com o projeto, com crédito e checksum |
| `godot-visual-craft` | Shaders realistas, materiais PBR avançados e animação com peso |
| `godot-audio-cinematics` | Direção de áudio, cutscenes com pulo seguro e gramática de câmera |
| `godot-skills-updater` | Checagem de atualização **só na fonte oficial** `jean-amaral/godot-skills`: avisa, mostra o que mudou e só atualiza com confirmação |

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
| Antigravity | `~/.gemini/config/skills/` e `~/.gemini/antigravity/skills/` — **cópias reais**, não links: o Antigravity CLI não segue junction/symlink ao descobrir skills (verificado no `agy`); o `update` re-sincroniza as cópias a cada pull |

Sem argumentos, o instalador abre um menu e você escolhe os agentes (1) Claude Code, (2) Codex, (3) OpenCode, (4) Antigravity — dá para combinar, ex.: `2,4` — ou todos. Instalação direta sem menu: `.\install\install.ps1 -Agents claude,codex` ou
`./install/install.sh claude codex`. Um diretório real já existente no
destino **nunca** é apagado sem `-Force`: o instalador pula e avisa.

## Atualização automática

O instalador registra, por padrão, uma atualização a cada 4 horas (e no login no Windows, quando o sistema permite registrar o gatilho)
(Tarefa Agendada no Windows, cron no Linux, LaunchAgent no macOS) que roda
`git pull --ff-only` neste clone. Como cada agente lê as skills por link
(junction/symlink) para dentro do clone, **atualizou o clone, atualizou
todos os agentes** — sem copiar nada.

- Desligar na instalação: `-NoAutoUpdate` (Windows) ou `NO_AUTO_UPDATE=1` (macOS/Linux).
- Atualizar na hora: `install\update.ps1` ou `install/update.sh`.
- Desinstalar links e a tarefa: `.\install\install.ps1 -Uninstall` ou `./install/install.sh --uninstall` (o clone e diretórios reais seus ficam intactos).

### Checagem com confirmação (skill `godot-skills-updater`)

Além da tarefa automática, o instalador grava o caminho do clone em
`~/.godot-skills/clone-path.txt` e um bloco-gatilho nas regras globais de
cada agente (`CLAUDE.md`/`AGENTS.md`/`GEMINI.md`). Com isso, no início da
primeira tarefa da sessão o agente carrega a skill `godot-skills-updater`:
ela roda `git fetch` **somente** em `jean-amaral/godot-skills` (a URL é
fixa no script e a identidade do clone é conferida antes da rede; qualquer
outra origem é recusada), avisa se houver versão nova mostrando os commits
e **só atualiza com a confirmação do criador**. Sem internet, segue o
trabalho em silêncio. A checagem acontece no máximo uma vez por hora.

> A atualização automática depende do agendador do sistema operacional
> estar ativo (tarefa/cron/launchd habilitado). Sem ele, a atualização é o
> `update` manual acima — um comando.

## Versões

- **Pacote**: `v1.0.0-10.2026` foi a primeira distribuição pública;
  a vigente é `v1.0.1-10.2026`. Os reforços de atualização automática (login +
  a cada 4h, log em `update.log`) e a skill `godot-skills-updater` (checagem
  com origem fixada em `jean-amaral/godot-skills` e confirmação do criador)
  foram incorporados **sem mudar o número da versão**. Conteúdo validado
  na Godot 4.7.2 (suítes de teste dentro de cada skill, em `tests/`).
- Cada skill mantém seu histórico interno no próprio `CHANGELOG.md`.

## Desenvolvimento

As suítes ficam dentro de cada skill (`skills/<skill>/tests/run_tests.ps1`,
requerem uma Godot 4.7+ via `GODOT_PATH`). Rode-as antes de publicar
mudança em `scripts/` ou `shaders/` de qualquer skill.
