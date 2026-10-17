# Changelog — pacote godot-skills

Histórico do pacote inteiro. Cada skill também mantém o próprio histórico
interno no seu `CHANGELOG.md`.

## v1.0.9-10.2026 — 2026-10-17 (consolidação)

21 skills, cobrindo o ciclo completo de um jogo Godot 2D/3D:

- **Criação**: `godot-3d-specialist`, `godot-2d-specialist`,
  `godot-visual-craft`, `godot-2d-visual-craft`, `godot-audio-cinematics`,
  `godot-ui-ux`, `godot-game-menus`, `godot-inventory-hotbar` (com
  entrevista de design), `godot-free-assets` (só CC0/CC-BY).
- **Online**: `godot-multiplayer` (núcleo, da documentação oficial),
  `godot-multiplayer-3d` e `godot-multiplayer-2d`.
- **Engine e plugins**: `godot-engine-resources` (Tween, Timer, Resource,
  Curve, Noise, PathFollow), `godot-plugins-installer`,
  `godot-phantom-camera`, `godot-csg-blockout` e `godot-ai-mcp` — plugins
  nas versões oficiais Phantom Camera v0.11.0.3, CSG Blockout v3.1.0 e
  Godot AI v4.3.0.
- **Entrega**: `godot-localization` (todo jogo nasce em pt-BR + en),
  `godot-performance-testing` e `godot-export-release`.
- **Método**: `agent-frontier-reasoning` e a seção **Pesquisa sempre** em
  todas as skills — pesquisar referências atuais (documentação oficial,
  imagem, vídeo e texto) antes de criar é regra do pacote inteiro.

Instalação sem scripts: cole o texto de instalação do README na sua IA;
ela instala e procura atualizações ao iniciar. A skill
`godot-skills-updater` e a pasta `install/` foram removidas nesta linha.

Fora de escopo (registrado): servidor dedicado avançado
(rollback/matchmaking), jogos de turno/cartas/ritmo, console sob NDA,
IAP mobile nativo e VR/OpenXR.

## v1.0.3-10.2026 — 2026-10-16

- Skill `godot-skills-updater`: checagem de atualização com fonte fixada
  no repositório oficial e confirmação do criador (removida em v1.0.9).

## v1.0.2-10.2026 — 2026-10-16

- Correção dos gatilhos de atualização automática (login + a cada 4 h).

## v1.0.1-10.2026 — 2026-10-16

- Atualização automática reforçada, com log em `update.log`.

## v1.0.0-10.2026 — 2026-10-16

- Primeira distribuição pública do pacote.
