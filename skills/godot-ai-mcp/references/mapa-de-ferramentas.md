# Mapa de ferramentas (Godot AI v4.3)

Conferido em `docs/TOOLS.md` do repositório oficial em 2026-10-17: 46 ferramentas, 120+ operações. Nome aqui = nome no cliente MCP; dentro de `batch_execute` e como `op` dos `*_manage`, usa-se o **comando do plugin** (ex.: `create_node`), não o nome MCP.

## Leitura (prefira resources quando bastar)

| Precisa | Ferramenta | Resource equivalente |
|---|---|---|
| Estado do editor/cena/prontidão | `editor_state` | `godot://editor/state`, `godot://scene/current` |
| Árvore da cena | `scene_get_hierarchy` (pagine: cena grande trunca) | `godot://scene/hierarchy` (100 nós) |
| Propriedades de um nó | `node_get_properties` | `godot://node/{path}/properties` |
| API de uma classe | `api_manage get_class` | `godot://class/{class_name}` |
| Script | `script_manage read/find_symbols` | `godot://script/{path}` |
| Materiais/shaders do projeto | `material_manage list/get` | `godot://materials`, `godot://visual_shader/{path}`, `godot://shader/{path}` |
| Entradas, performance, sessões | `input_map_manage list`, `editor_manage monitors_get`, `session_manage list` | `godot://input_map`, `godot://performance`, `godot://sessions` |

## Escrita por domínio (`<dominio>_manage` com `op`)

- **Cena/nós**: `scene_manage` (create, save_as, get_roots) · `node_manage` (get_children, delete, duplicate, rename, move, reparent, grupos) · diretos: `node_create`, `node_set_property`, `node_find`.
- **Script**: `script_create` (valida parse, hot-reload), `script_attach`, `script_patch` (edição por âncora); `script_manage` (read, detach, find_symbols em `.gd`/`.cs`).
- **Gameplay/sistemas**: `signal_manage` (list/connect/disconnect) · `input_map_manage` (ações e binds) · `autoload_manage` · `navigation_manage` (bake, path_get) · `csg_manage` (csg_create, csg_set_operation) · `physics` via `resource_manage` (physics_shape_autofit/generate).
- **Visual/áudio**: `animation_manage` (+ `animation_create`, presets fade/slide/shake/pulse) · `material_manage` (material, shader com validate/patch, VisualShader por grafo) · `particle_manage` (presets) · `audio_manage` (players/streams) · `camera_manage` (criar/configurar, limites/damping/follow 2D, presets — câmera nativa; Phantom Camera é nó comum, skill própria).
- **UI**: `ui_manage` (set_anchor_preset, set_text, set_richtext, build_layout, draw_recipe) + `theme_manage` (cores, constantes, fontes, StyleBox, apply) — desenho da experiência é com `godot-ui-ux`.
- **Mapas**: `tilemap_manage`, `tileset_manage`, `gridmap_manage`.
- **Recursos**: `resource_manage` (search/load/inspect/assign/create, Curve, Environment, GradientTexture, NoiseTexture).
- **Cliente/edição**: `client_manage` (status/configure/remove dos clientes MCP) · `filesystem_manage` (read/write_text, reimport, scan, search, move) · `custom_manage` (ferramentas customizadas do projeto).

## Rodar, testar, ver

- `project_run` toca o projeto e espera o jogo ficar vivo (autosave das edições em memória por padrão); `project_manage stop` para.
- `game_manage`: árvore **viva** do jogo, elementos de UI em runtime, suspender/retomar, avançar frame e **injetar entrada** (tecla, mouse, gamepad, ação, sequência) — testar jogando de verdade, sem tocar no teclado do criador.
- `test_run` executa suites GDScript (`McpTestSuite`); resultado em `test_manage results_get`.
- `logs_read`: buffers do plugin/jogo/editor; `source="editor"` traz parse, warnings de reload e erros de @tool/EditorPlugin — a fonte da verdade depois de erro vermelho.
- `editor_screenshot`: `viewport` (3D do editor), `viewport_2d`, `cinematic` (Camera3D), `game` (framebuffer do jogo). Com Vision Routing ligado, volta descrição em texto em vez de imagem.
- `editor_reload_plugin` recarrega o plugin e espera reconectar — depois de atualizar o Godot AI ou mexer nele.

## Lote atômico

`batch_execute` executa vários comandos do plugin como uma unidade: **erro em um desfaz os anteriores**. Desenhe o lote para ser uma unidade lógica completa (criar o personagem inteiro) — lote gigante misturando coisas independentes transforma erro pequeno em rollback grande.

---
_Mapa conferido em 2026-10-17 (v4.3.0). Operação nova surge por release: confira `docs/TOOLS.md` da versão instalada antes de afirmar que um `op` existe._
