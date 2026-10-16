# Física e consultas espaciais 3D

Complementa [metricas-e-alinhamento.md](metricas-e-alinhamento.md) (pivôs e AABB) e a regra de nunca escalar corpo físico.

## CharacterBody3D que anda direito

- Movimento em `_physics_process` com `move_and_slide()`; velocidade montada a partir da direção desejada, gravidade aplicada à parte.
- Escada e degrau: `floor_snap_length` cobre degrau baixo sem pulo; rampa íngreme é `floor_max_angle` — acima dele é parede, não chão.
- Plataforma móvel: o corpo carrega o passageiro pelo movimento da plataforma; não some a velocidade da plataforma na do personagem sem testar em pé parado.
- Teste de escala continua obrigatório: cápsula (raio 0,4 m, altura 1,8 m) atravessa toda porta do nível.

## Matriz de layers (defina antes de codar)

| Layer | Nome | Quem usa |
|---|---|---|
| 1 | mundo_estático | Paredes, piso (`StaticBody3D`) |
| 2 | personagem | `CharacterBody3D` do jogador |
| 3 | inimigo | Corpos e hurtboxes de inimigo |
| 4 | projétil | Projéteis e áreas de dano |
| 5 | interagível | Áreas de interação |
| 6 | sensor | Triggers sem bloqueio (som, câmera, checkpoint) |

Regra: `collision_layer` = o que o corpo **é**; `collision_mask` = o que ele **enxerga**. Sensor não bloqueia ninguém (layer sem máscara de bloqueio recíproco). Nomeie as layers em Project Settings → Layer Names/3D Physics; código com número mágico de layer é dívida.

## Consultas espaciais (ray/shape/point)

- Sempre via `PhysicsDirectSpaceState3D` em contexto de física (`_physics_process` ou sinal de física), nunca em `_ready` antes do mundo existir.
- Ray de tiro/picking: `intersect_ray` com `exclude` contendo o RID de quem atira — sem isso o primeiro hit é o próprio atirador.
- "Tem espaço para nascer/ficar de pé?" é consulta de **forma** (`intersect_shape` com a cápsula), não três rays criativos.
- Picking de mouse em 3D: projete com `camera.project_ray_origin/normal()` e ray físico; `CollisionObject3D.input_event` serve para caso simples, mas o ray manual compõe com camadas e alcance.
- Resultado é dicionário tipado na leitura (`hit["normal"] as Vector3` com checagem), nunca índice cru repetido.

## Física especial (sob demanda)

- **Ragdoll**: ossos físicos (`PhysicalBone3D`) ativados na morte, desativados no resto do tempo — ragdoll sempre ativo briga com a animação.
- **Veículo**: corpo com rodas por raycast (suspensão), não quatro esferas físicas; comece pelo comportamento, não pelo realismo.
- **SoftBody/joints**: protótipo isolado primeiro; custo e instabilidade sobem rápido no Jolt com malha densa.
- Em todos: forma simples vence malha fiel. Colisor é aproximação jogável, não réplica do modelo.

---
_Referência revisada em 2026-10-16 (Godot 4.7.2). A suíte `tests/` prova os scripts do pacote; as receitas daqui são orientação de uso, não comportamento testado. Documentação oficial: [classes](https://docs.godotengine.org/en/stable/classes/index.html) · [linha de comando](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html)._
