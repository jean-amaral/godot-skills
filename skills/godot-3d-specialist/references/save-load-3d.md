# Save/Load e persistência de mundo 3D

Implementação pronta: [../scripts/save_system.gd](../scripts/save_system.gd) (JSON, escrita atômica com `.bak`, validação campo a campo), testada em ida-e-volta pela suíte `tests/`.

## Formato

- Arquivo em `user://saves/save_slot_01.json` (JSON) ou binário via `FileAccess.store_var()` **só com tipos primitivos**.
- **Nunca** carregue `.tres`/`.res` vindos de `user://`: recurso pode embutir script e virar execução de código do jogador. Esta é a regra de segurança nº 1 do sistema.
- Inclua `"version": 1` no topo e migre formato explicitamente ao mudá-lo.
- Integridade: o `SaveSystem` grava `"sha256"` da lista de entidades e recusa payload adulterado/truncado; recusado no principal, ele tenta o `.bak` uma vez antes de desistir. Versão antiga só entra pelo gancho `migrate_save()` sobrescrito no projeto — sem migração escrita, recusa.

## O que salvar por entidade

Entidades persistentes entram no grupo `"persist_3d"` e expõem id estável:

```json
{
  "version": 1,
  "player": { "transform": [0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0] },
  "entities": [
    {
      "id": "porta_lab_01",
      "scene": "res://scenes/props/door.tscn",
      "origin": [4.0, 0.0, -2.0],
      "quat": [0.0, 0.7071, 0.0, 0.7071],
      "state": { "open": true, "locked": false }
    }
  ]
}
```

- Posição: `global_transform.origin` (x, y, z).
- Rotação: `global_transform.basis.get_rotation_quaternion()` (x, y, z, w). Não salve Euler — gimbal e ordem de eixo viram bug de load.
- Escala de nó persistido deve ser `Vector3.ONE`; se um prop precisar de escala, ela faz parte do `state` validado, nunca do corpo físico.
- Estado de gameplay (`open`, `hp`, `collected`) vai no dicionário `state` da entidade, com chave conhecida.

## Contrato de código

```gdscript
# Na entidade persistente:
func get_save_state() -> Dictionary:
	return {"open": is_open}

func apply_save_state(state: Dictionary) -> void:
	is_open = bool(state.get("open", false))
```

Ao carregar:

1. Leia e faça parse; JSON inválido = save corrompido → avise e não aplique nada (nunca aplique pela metade).
2. Valide tipo de cada campo antes de usar (`is` / `as` com checagem de nulo).
3. Entidade com `id` existente: restaure transform + `apply_save_state`. Entidade nova no save: instancie de `scene` (caminho precisa começar com `res://` e existir — valide com `ResourceLoader.exists()`).
4. Entidade do mundo ausente no save (item coletado): remova ou oculte conforme a regra do jogo, registrada no TDD.

## Escrita atômica

Escreva em `save_slot_01.json.tmp` e renomeie para o nome final (`DirAccess.rename_absolute`). Queda de energia no meio da escrita não pode destruir o save bom anterior. Mantenha ao menos um backup rotativo (`.bak`) por slot.


---

_Última verificação: 2026-10-16, Godot 4.7.2 (suíte `tests/`). Documentação oficial: [classes](https://docs.godotengine.org/en/stable/classes/index.html) · [linha de comando](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html)._
