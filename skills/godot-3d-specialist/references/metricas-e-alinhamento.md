# Métricas, pivôs e alinhamento por AABB

## Sistema de eixos (Godot, mão direita)

- `Vector3.UP = (0, 1, 0)` — para cima.
- `Vector3.FORWARD = (0, 0, -1)` — frente de câmeras e personagens é **-Z**.
- `Vector3.RIGHT = (1, 0, 0)` — direita é +X.
- Rotação positiva gira no sentido anti-horário olhando do eixo positivo para a origem.

## Escala métrica (1 unidade = 1 metro)

| Elemento | Medida padrão |
|---|---|
| Módulo de piso/teto | 1 m, 2 m ou 4 m em X/Z; espessura 0,1–0,2 m |
| Parede interior | 3,0 m de altura; galpão/corredor 4,0 m; espessura 0,2 m |
| Porta/passagem | 1,0–1,2 m de largura × 2,1–2,4 m de altura |
| Cápsula do personagem | raio 0,4 m, altura total 1,8 m |

Toda medida de prop entra no catálogo ([../templates/prop-catalog.md](../templates/prop-catalog.md)) antes de modelar.

## Regra do pivô

- **Prop de chão** (móvel, poste, árvore, personagem): origem na **base central**, `Y = 0` tocando o piso. Instanciar é `position = cota_do_piso`, sem conta extra.
- **Primitiva centrada** (`BoxMesh`, `CylinderMesh` etc.): a malha e o `CollisionShape3D` filhos sobem `size.y * 0.5`; a raiz fica na cota do piso.

```text
StaticBody3D (raiz, y = cota do piso)
├── MeshInstance3D      position.y = altura / 2
└── CollisionShape3D    position.y = altura / 2   (BoxShape3D.size = dimensões reais)
```

- **Kit arquitetônico**: posição em múltiplos do grid com `snappedf(valor, 0.5)` por eixo e rotação Y em múltiplos de 90°. Após rotacionar por código, normalize: `transform.basis = transform.basis.orthonormalized()`.

## Alinhamento por AABB — a matemática certa

`MeshInstance3D.get_aabb()` retorna a caixa no espaço **local** da malha. Para alinhar no mundo, multiplique pelo transform global — com um porém: fora da árvore (cena instanciada, `_initialize`, ferramenta headless) `global_transform` é inválido e retorna identidade. Por isso o `PropAligner` **acumula o transform pela cadeia de ancestrais** em vez de ler `global_transform`:

```gdscript
# dentro da árvore, isto basta:
var global_aabb: AABB = mesh_inst.global_transform * mesh_inst.get_aabb()
# fora da árvore, use PropAligner.get_global_aabb(node) — ver scripts/prop_aligner.gd
```

Erros comuns da versão ingênua (não repita):

1. Usar `aabb.position.y * scale.y` como base ignora pai deslocado, rotação e translação da própria malha.
2. Encostar props somando `position.x` locais quebra assim que um dos dois tem pai diferente ou rotação de 90°.
3. Apoiar em rampa com `normal.cross(forward)` espelha o prop: o correto é `forward.cross(normal)` para obter a direita.

As três operações prontas e testáveis estão em [../scripts/prop_aligner.gd](../scripts/prop_aligner.gd):

- `snap_to_floor(node, floor_y)` — assenta qualquer `Node3D` com malha filha pela AABB global.
- `place_adjacent(reference, target, axis, gap)` — encosta dois props sem sobreposição.
- `place_on_surface(node, space_state, from)` — raycast físico + basis ortonormal com Y na normal.

## Tolerâncias

- Encaixe no piso: |base − cota| ≤ 0,001 m. Abaixo disso é flutuação/afundamento visível em sombra de contato.
- Sobreposição entre props vizinhos: 0 m. Gap intencional é parâmetro explícito, nunca acidente de arredondamento.


---

_Última verificação: 2026-10-16, Godot 4.7.2 (suíte `tests/`). Documentação oficial: [classes](https://docs.godotengine.org/en/stable/classes/index.html) · [linha de comando](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html)._
