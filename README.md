# godot-skills

Pacote de skills Godot para agentes de código (Antigravity, OpenCode, Codex e
Claude): desenvolvimento 3D com padrão de qualidade alto, assets gratuitos
com licença verificada, criação visual e áudio/cinematografia — sempre com
pesquisa e referências antes de construir.

**Versão do pacote: `v1.9.0-10.2026`** (ver [VERSION](VERSION) e [releases](#versões))

## Skills incluídas

| Skill | Para quê |
|---|---|
| `godot-3d-specialist` | Jogo 3D na Godot 4.7+: concepção por entrevista, planejamento, CSG→bake, props modulares realistas, auditoria headless, save/load e devlog |
| `godot-free-assets` | Buscar e baixar assets **100% gratuitos (só CC0/CC-BY)** compatíveis com o projeto, com crédito e checksum |
| `godot-visual-craft` | Shaders realistas, materiais PBR avançados e animação com peso |
| `godot-audio-cinematics` | Direção de áudio, cutscenes com pulo seguro e gramática de câmera |
| `godot-ui-ux` | HUD, menus e experiência do jogador: hierarquia de informação, fluxos, onboarding, acessibilidade e testes de usabilidade |
| `agent-frontier-reasoning` | Como o agente pensa e cria em qualquer domínio: pesquisar na internet antes de criar, gerar alternativas, decidir por critérios, verificar com evidência e revisar o próprio trabalho |
| `godot-plugins-installer` | Baixar e instalar da fonte oficial os plugins do fluxo: Phantom Camera, CSG Blockout e Godot AI (MCP), com versão certa para a engine |
| `godot-phantom-camera` | Câmeras com Phantom Camera: Host/PCams, prioridades, follow (incl. terceira pessoa), transições, tween e shake |
| `godot-csg-blockout` | Blockout de nível com CSG Blockout: desenhar, medir contra o personagem, jogar no espaço e congelar em malha reversível |
| `godot-ai-mcp` | Operar o editor Godot vivo pelo MCP Godot AI: ler, criar, rodar, testar e depurar com logs e screenshots |
| `godot-2d-specialist` | Jogo 2D na Godot 4.7+: movimento de plataforma/top-down com números em tiles, TileMapLayer, física 2D e estados de personagem |
| `godot-2d-visual-craft` | Arte 2D: pixel art sem borrar, animação de sprite por estado, tileset/parallax e luz/shader 2D |
| `godot-multiplayer` | Multiplayer (núcleo): autoridade, RPC, spawn/sincronização, lobby, banda e segurança — da documentação oficial |
| `godot-multiplayer-3d` | Multiplayer 3D: avatar/física sincronizados com interpolação, tiro validado e áreas de interesse |
| `godot-multiplayer-2d` | Multiplayer 2D: movimento preciso em rede, estado de TileMap e co-op de câmera |
| `godot-engine-resources` | Peças da engine sem reinventar: Tween, Timer, Resource, Curve, Gradient, FastNoiseLite e PathFollow |
| `godot-export-release` | Exportar e publicar: presets e templates, CLI headless, Windows/Web/Android, assinatura e checklist de lançamento |
| `godot-performance-testing` | Depuração, profiling com monitores oficiais, otimização medida e testes automatizados |
| `godot-localization` | Localização desde o primeiro texto: todo jogo em pt-BR + en, chaves com `tr()`, pipeline CSV/PO e troca em runtime |
| `godot-game-menus` | Menus de jogo: título, principal, pausa, configurações, slots de save e créditos, com navegação e estados certos |
| `godot-inventory-hotbar` | Inventário e hotbar a partir de entrevista de design: modelo de itens, limites, operações, arrastar e navegação por controle |

## Instalação

Cole este texto na sua IA:

```text
Instale as skills "https://github.com/jean-amaral/godot-skills.git" para serem usadas pelo Antigravity, e lembre-se de sempre procurar por atualizações quando iniciar.
```

A IA faz todo o processo automaticamente e tenta se manter atualizada.
Troque `Antigravity` pelo seu agente, se for outro.

Para desinstalar, peça: `Desinstale as skills de "https://github.com/jean-amaral/godot-skills.git" instaladas para o Antigravity.`

## Versões

- **Pacote**: `v1.0.0-10.2026` foi a primeira distribuição pública. A
  vigente, `v1.9.0-10.2026`, ganha `godot-inventory-hotbar` (inventário e
  hotbar desenhados a partir de entrevista com o criador, além da pesquisa
  de referências). Com isso o pacote cobre 2D, 3D, online, menus,
  inventário e lançamento; servidor dedicado avançado segue fora de escopo.
  Instalar é colar o texto acima na IA, e é ela quem procura
  atualizações ao iniciar. Conteúdo validado na Godot 4.7.2 (suítes de
  teste dentro de cada skill, em `tests/`).
- Cada skill mantém seu histórico interno no próprio `CHANGELOG.md`.

## Desenvolvimento

As suítes ficam dentro de cada skill (`skills/<skill>/tests/run_tests.ps1`,
requerem uma Godot 4.7+ via `GODOT_PATH`). Rode-as antes de publicar
mudança em `scripts/` ou `shaders/` de qualquer skill.
