# Auditoria automática de cenas e validação headless

O auditor ([../scripts/scene_auditor.gd](../scripts/scene_auditor.gd)) roda sem abrir o editor e escreve `audit_report.json` para o devlog HTML e para o CI.

## Como rodar

```bash
# Uma ou várias cenas (argumentos após -- são repassados ao script)
godot --headless --script res://scripts/tools/scene_auditor.gd -- res://scenes/environments/main_level.tscn

# Com configuração do projeto (ignores e limites) e várias cenas:
godot --headless --script res://scripts/tools/scene_auditor.gd -- --config=res://audit_config.json res://a.tscn res://b.tscn

# Importar e validar o projeto inteiro
godot --headless --import --quit

# Timelapse bruto a partir de câmeras fixas (frames para o ffmpeg)
godot --path . --write-movie devlog/timelapses/step.avi --fixed-fps 60 --quit-after 300
```

Código de saída: `0` sem erros, `1` com erro ou cena inválida. CI reprova o build em erro; aviso não reprova, mas aparece no relatório.

## O que é checado

| Código | Severidade | Regra |
|---|---|---|
| `NON_UNIFORM_SCALE` | erro | `CollisionObject3D` com escala não-uniforme distorce a forma no Jolt |
| `SCALED_PHYSICS_BODY` | aviso | Corpo físico com escala uniforme ≠ 1: mova o tamanho para a `Shape3D` |
| `MISSING_COLLISION_SHAPE` | erro | Corpo físico sem `CollisionShape3D` filho com `shape` válida |
| `EMPTY_MESH_INSTANCE` | aviso | `MeshInstance3D` sem `mesh` (placeholder esquecido ou import quebrado) |
| `FLOATING_PROP` | aviso | Prop do grupo `floor_props` com base da AABB global a mais de 1 mm da cota esperada |
| `DUPLICATE_NODE_NAME` | aviso | Irmãos com o mesmo nome quebram caminhos `$Nome` e âncoras de save por caminho |
| `TOO_MANY_LIGHTS` | aviso | `Light3D` acima de `max_lights` da configuração |
| `TEXTURE_TOO_LARGE` | aviso | Textura de albedo acima de `max_texture_size` da configuração |

Configuração (`audit_config.json`): `ignore_types` (tipos ignorados por completo), `ignore` (lista de `{type, node_prefix}` para exceções pontuais conhecidas), `max_lights` e `max_texture_size` (limites do projeto; ausente = sem limite). Issue ignorada não entra no relatório — registre o motivo no TDD, não só no JSON.

## Limites honestos da auditoria

- Sem adicionar a cena à árvore, não há física nem `_ready`: a auditoria é **estrutural** (transform, forma, malha), não comportamental.
- `FLOATING_PROP` usa a AABB global da malha; prop sem malha ou com malha propositalmente suspensa (luminária de teto) fica fora do grupo `floor_props`.
- O grupo `floor_props` precisa estar atribuído **na cena** (pelo editor). Grupo adicionado em runtime com `add_to_group("floor_props")` usa `persistent=false` por padrão e **não é salvo no `.tscn`** — a checagem simplesmente não enxerga o prop. Verificado na Godot 4.7.2.
- Colisor checado é o `CollisionShape3D` filho direto do corpo — que é onde a Godot espera a forma; forma neta dentro de outro nó não conta.
- Relatório em execução headless de editor/CI pode ir para `res://devlog/`; no jogo exportado, `res://` é leitura — use `user://`.

## Checklist de entrega de cena

1. `godot --headless --import --quit` sem erro.
2. Auditor com **0 erros**; avisos restantes justificados no devlog.
3. Cena abre no editor sem nó quebrado nem recurso faltando.
4. Personagem atravessa todas as portas e o nível inteiro sem prender (teste manual ou automatizado de navegação).


---

_Última verificação: 2026-10-16, Godot 4.7.2 (suíte `tests/`). Documentação oficial: [classes](https://docs.godotengine.org/en/stable/classes/index.html) · [linha de comando](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html)._
