# Ferramentas, formas e settings (CSG Blockout 3.1)

Conferido no repositório oficial (`scripts/`, `csg_blockout_config.gd`) em 2026-10-17. Tutorial completo do autor: `TUTORIAL_EN.md` no repositório do plugin.

## Ferramentas de viewport (o gesto do criador)

- **Paleta** à esquerda do viewport 3D (sempre visível) e **pie menu** com `Shift+A` no cursor (tecla de ação configurável). Clique duplo numa ferramenta a mantém ativa; `Esc`/botão direito sai. O cartão no topo do viewport diz o próximo passo.
- **Draw**: arrastar a base em qualquer superfície cria a caixa com a última altura usada. **Cut**: arrastar abre vão atravessando a superfície (em parede solta, o plugin a envolve num combiner sozinho). **Room**: arrastar o contorno do piso constrói a casca (parede/piso/teto conforme settings).
- **Door/Window**: clicar na parede corta porta no piso ou janela na altura do peitoril, com moldura opcional (`F`). Portas/janelas **seguem a parede** quando ela se move.
- **Setas de face**: forma selecionada mostra seta em cada face voltada para você — arrastar empurra/puxa aquela face (a oposta fica). Clicar no rótulo de dimensão aceita tamanho digitado. Setas de teclado andam um passo de grade; `[` `]` mudam a grade; rotação em passos de 15°.
- **Grid materials**: grade alinhada ao mundo de 1 m (clara/escura/laranja) aplicada em lote na seleção — textura que não estica é o que torna a medida legível.

## Formas próprias (o que o agente cria por nó/script)

| Classe | Base | Parâmetros-chave |
|---|---|---|
| `CSGStairs3D` | `CSGPolygon3D` | altura, profundidade, largura, nº de degraus; modo rampa suave; avisa degrau desconfortável |
| `CSGWedge3D` | `CSGPolygon3D` | `size` — bloco inclinado (rampa, telhado) |
| `CSGArch3D` | `CSGPolygon3D` | `size`, `opening_width`, `opening_height` — parede com vão em arco |
| `CSGCurvedWall3D` | `CSGPolygon3D` | `radius`, `thickness`, `height`, varredura até anel fechado |
| `CSGSpiralStairs3D` | `CSGMesh3D` | `height`, `outer_radius`, `inner_radius`, `step_thickness`, `clockwise`; avisa vão livre baixo sobre o giro |
| `CSGRepeater3D` | `CSGCombiner3D` | repete em grade/círculo/espiral/ruído, com rotação/escala/jitter aleatórios — **Bake antes de publicar** |
| `CSGSpreader3D` | `CSGCombiner3D` | espalha até 200 cópias dentro de um `Shape3D` sem sobrepor — **Bake antes de publicar** |
| `CSGPlayerReference3D` | `Node3D` (só editor) | `use_global_metrics`, `show_jump_arc`, `show_slope` — cápsula, agachar, olho, pulo e arco de pulo com corrida |
| `CSGRuler3D` | `Node3D` | régua entre dois pontos / checagem de vão pulável entre dois objetos |

Escada/rampa/arco/parede curva sem o plugin viram `CSGPolygon3D` comum com a mesma forma; escada espiral vira `CSGMesh3D` com a malha salva na cena.

## Project Settings do plugin (`addons/csg_blockout/*`)

| Setting | Default | Para quê |
|---|---|---|
| `room/wall_thickness`, `room/floor_thickness`, `room/height`, `room/open_top` | 0,25 · 0,25 · 3,0 · aberto | Casca do Room |
| `openings/door_size`, `openings/window_size`, `openings/window_sill_height` | 1,0×2,1 · 1,2×1,2 · 0,9 | Portas e janelas cortadas |
| `openings/add_frame`, `openings/frame_width` | desligado · 0,1 | Moldura do vão |
| `player_metrics/character_height`, `capsule_radius`, `crouch_height` | 1,8 · 0,35 · 1,0 | O corpo contra o qual o nível é medido |
| `player_metrics/single_jump_height`, `sprint_jump_distance` | 1,5 · 4,0 | O que o personagem alcança |
| `player_metrics/max_slope_angle`, `max_step_height`, `walk_speed` | 45° · 0,3 · 3,5 | Rampa/step/ritmo do Check e do Play From Here |
| `material_preset`, `custom_material_path` | grade clara | Material de blockout |

Agente: ajuste `player_metrics` **do projeto real** (altura/pulo do personagem do jogo) antes de desenhar — `ProjectSettings` via código/MCP (`project_manage settings_set`) ou editor. Métrica padrão contra personagem diferente invalida Check, arco de pulo e avisos de escada ao mesmo tempo.

## Medição e checagem (o diferencial do plugin)

- **Check** (barra superior): rampa acima de `max_slope_angle` e teto abaixo de altura em pé/agachado, destacados no viewport e listados na aba Checks do outliner (**Next** pula de problema em problema).
- **Rótulos de dimensão** em metros na forma selecionada; régua e "vão pulável?" entre dois objetos selecionados.
- **Tags semânticas** (parede/piso/perigo/interativo): cor de grade própria + metadado que o jogo lê; exporta legenda SVG para documento de design.
- **Outliner de blockout** (dock): só árvores CSG e congelados, com operação, mostrar/ocultar, solo, trava, grupos e nomes semânticos (`Wall_Corridor_01`).

---
_Conferido em 2026-10-17 no repositório oficial `qwqzhanqwq/Godot-CSG-Blockout` (v3.1.0, Godot 4.6+)._
