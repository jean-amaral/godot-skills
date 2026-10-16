# Catálogo de props modulares

Pivô padrão: base central (`Y = 0` no piso). Colisor: forma Jolt do `.tscn`, nunca escala no corpo físico.

| Prop (`.tscn`) | Dimensões X×Y×Z (m) | Pivô | Colisor | Status |
|---|---|---|---|---|
| `props/wall_2m.tscn` | 2,0 × 3,0 × 0,2 | Base | `BoxShape3D` estático | ✅ pronto |
| `props/floor_2m.tscn` | 2,0 × 0,2 × 2,0 | Base | `BoxShape3D` estático | 🔨 modelando |
| `props/door_1m.tscn` | 1,0 × 2,2 × 0,15 | Base | `BoxShape3D` + área de interação | ⬜ planejado |

Status: ⬜ planejado · 🔨 em produção · ✅ pronto (auditado, 0 erros).

Regras do catálogo:

- Uma linha por prop **antes** de modelar; dimensão muda no catálogo primeiro, depois no Blender e no `.tscn`.
- Prop sem linha no catálogo não entra no nível.
- Ao concluir, confira a AABB real com o `PropAligner` e corrija a linha se divergir.
