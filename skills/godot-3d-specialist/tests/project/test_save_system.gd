extends SceneTree

var _failures := 0
var _ran := false
var _entity: SaveTestEntity
var _system: SaveSystem

func _check(label: String, cond: bool, detail: String = "") -> void:
	print(("PASS " if cond else "FAIL ") + label + " " + detail)
	if not cond:
		_failures += 1

func _initialize() -> void:
	_system = SaveSystem.new()
	root.add_child(_system)
	_entity = SaveTestEntity.new()
	_entity.name = "Door"
	_entity.set_meta("save_id", "door_01")
	_entity.add_to_group("persist_3d")
	root.add_child(_entity)
	process_frame.connect(_run)

func _run() -> void:
	if _ran:
		return
	_ran = true
	_entity.global_position = Vector3(4, 0, -2)
	_entity.global_rotation.y = PI * 0.5
	_entity.is_open = true
	_check("save retorna OK", _system.save_game("test_slot") == OK)
	_check("arquivo existe", FileAccess.file_exists("user://saves/test_slot.json"))
	_check("backup nao exigido na 1a escrita", true)

	_entity.global_position = Vector3.ZERO
	_entity.global_rotation.y = 0.0
	_entity.is_open = false
	_check("load retorna OK", _system.load_game("test_slot") == OK)
	_check("posicao restaurada", _entity.global_position.is_equal_approx(Vector3(4, 0, -2)),
		str(_entity.global_position))
	_check("rotacao restaurada", absf(wrapf(_entity.global_rotation.y, -PI, PI) - PI * 0.5) < 0.001,
		str(_entity.global_rotation.y))
	_check("estado restaurado", _entity.is_open)

	# Save corrompido: erro, e nada é aplicado pela metade.
	var file := FileAccess.open("user://saves/corrupt.json", FileAccess.WRITE)
	file.store_string("{ isto nao e json")
	file.close()
	var before: Vector3 = _entity.global_position
	_check("load corrompido falha", _system.load_game("corrupt") != OK)
	_check("corrompido nao aplica nada", _entity.global_position.is_equal_approx(before))

	# Segunda escrita gera .bak; corromper o principal cai para o backup.
	_check("segunda escrita gera .bak", _system.save_game("test_slot") == OK
		and FileAccess.file_exists("user://saves/test_slot.json.bak"))
	var main_file := FileAccess.open("user://saves/test_slot.json", FileAccess.WRITE)
	main_file.store_string("lixo adulterado")
	main_file.close()
	_entity.global_position = Vector3.ZERO
	_check("principal corrompido usa .bak", _system.load_game("test_slot") == OK
		and _entity.global_position.is_equal_approx(Vector3(4, 0, -2)))

	_check("slot inexistente falha", _system.load_game("slot_que_nao_existe") == ERR_FILE_NOT_FOUND)

	# Spawn sem cena atual: entidade ausente volta da cena salva, sob a raiz.
	var door := SaveTestEntity.new()
	door.name = "SpawnDoor"
	var door_packed := PackedScene.new()
	_check("empacota porta de spawn", door_packed.pack(door) == OK
		and ResourceSaver.save(door_packed, "res://scenes/save_door.tscn") == OK)
	door.free()
	var manual := FileAccess.open("user://saves/spawn_manual.json", FileAccess.WRITE)
	manual.store_string(JSON.stringify({"version": 1, "entities": [{
		"id": "spawn_01", "scene": "res://scenes/save_door.tscn",
		"origin": [1.0, 2.0, 3.0], "quat": [0.0, 0.0, 0.0, 1.0],
		"state": {"open": true}}]}))
	manual.close()
	_check("load com spawn retorna OK", _system.load_game("spawn_manual") == OK)
	var spawned: SaveTestEntity = null
	for node: Node in get_nodes_in_group("persist_3d"):  # este script É a SceneTree
		if node.has_meta("save_id") and String(node.get_meta("save_id")) == "spawn_01":
			spawned = node as SaveTestEntity
	_check("entidade spawnada encontrada", spawned != null)
	if spawned != null:
		_check("spawn aplica transform e estado",
			spawned.global_position.is_equal_approx(Vector3(1, 2, 3)) and spawned.is_open)
	print("SAVE_DONE failures=", _failures)
	quit(1 if _failures > 0 else 0)
