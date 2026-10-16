class_name SaveSystem
extends Node

## Save/Load de mundo 3D em JSON validado, com escrita atômica e backup.
## Copie para res://scripts/autoloads/save_system.gd (ou instancie onde precisar).
##
## Contrato das entidades (grupo "persist_3d"):
##   - meta "save_id" (String única e estável), ex.: porta.set_meta("save_id", "porta_lab_01")
##   - func get_save_state() -> Dictionary
##   - func apply_save_state(state: Dictionary) -> void
## Nunca carrega .tres/.res de user:// — apenas JSON com tipos validados.

const SAVE_DIR := "user://saves"
const FORMAT_VERSION := 1

## Salva todas as entidades do grupo "persist_3d". Retorna OK ou o erro.
func save_game(slot: String = "save_slot_01") -> Error:
	var entities: Array[Dictionary] = []
	for node: Node in get_tree().get_nodes_in_group("persist_3d"):
		if not node.has_meta("save_id") or not node.has_method("get_save_state"):
			push_warning("SaveSystem: %s no grupo persist_3d sem save_id/get_save_state." % node.name)
			continue
		if not (node is Node3D):
			continue
		var n3d := node as Node3D
		var quat: Quaternion = n3d.global_transform.basis.get_rotation_quaternion()
		var origin: Vector3 = n3d.global_transform.origin
		entities.append({
			"id": String(node.get_meta("save_id")),
			"scene": node.scene_file_path,
			"origin": [origin.x, origin.y, origin.z],
			"quat": [quat.x, quat.y, quat.z, quat.w],
			"state": node.call("get_save_state"),
		})
	var payload := {
		"version": FORMAT_VERSION,
		"sha256": _checksum(entities),
		"entities": entities,
	}
	return _write_atomic(_slot_path(slot), payload)

## Gancho de migração: sobrescreva numa subclasse para converter saves de
## versões anteriores e devolva o payload já na FORMAT_VERSION (com
## "version" atualizada). Padrão: sem migração — versão antiga é recusada.
func migrate_save(_data: Dictionary, _from_version: int) -> Dictionary:
	return {}

## Carrega e aplica. Inválido no principal: tenta o .bak uma vez.
## Continua inválido (ou versão sem migração): não aplica nada.
func load_game(slot: String = "save_slot_01") -> Error:
	var path := _slot_path(slot)
	if not FileAccess.file_exists(path):
		return ERR_FILE_NOT_FOUND
	var data := _read_valid_payload(path)
	if data.is_empty() and FileAccess.file_exists(path + ".bak"):
		push_warning("SaveSystem: save principal inválido; usando backup de " + slot)
		data = _read_valid_payload(path + ".bak")
	if data.is_empty():
		printerr("SaveSystem: save inválido ou não suportado: ", path)
		return ERR_INVALID_DATA
	var raw_entities: Variant = data.get("entities", [])
	if not (raw_entities is Array):
		return ERR_INVALID_DATA

	var by_id: Dictionary[String, Node] = {}
	for node: Node in get_tree().get_nodes_in_group("persist_3d"):
		if node.has_meta("save_id"):
			by_id[String(node.get_meta("save_id"))] = node

	for raw: Variant in raw_entities:
		if not (raw is Dictionary):
			return ERR_INVALID_DATA
		var entry := raw as Dictionary
		var id := String(entry.get("id", ""))
		var origin_raw: Variant = entry.get("origin", [])
		var quat_raw: Variant = entry.get("quat", [])
		var state: Dictionary = entry.get("state", {}) if entry.get("state", {}) is Dictionary else {}
		if id.is_empty() or not _is_number_array(origin_raw, 3) or not _is_number_array(quat_raw, 4):
			printerr("SaveSystem: entrada inválida no save (id/origin/quat).")
			return ERR_INVALID_DATA
		var origin: Vector3 = _vec3_from(origin_raw)
		var quat: Quaternion = _quat_from(quat_raw)
		var target: Node = by_id.get(id, null)
		if target == null:
			target = _spawn_from_save(entry)
			if target == null:
				continue
		if target is Node3D and target.has_method("apply_save_state"):
			var n3d := target as Node3D
			n3d.global_transform = Transform3D(Basis(quat), origin)
			target.call("apply_save_state", state)
	return OK

func _spawn_from_save(entry: Dictionary) -> Node:
	var scene_path := String(entry.get("scene", ""))
	if not scene_path.begins_with("res://") or not ResourceLoader.exists(scene_path):
		push_warning("SaveSystem: cena não restaurável: '%s'" % scene_path)
		return null
	var packed := load(scene_path) as PackedScene
	if packed == null:
		return null
	var node: Node = packed.instantiate()
	node.set_meta("save_id", String(entry.get("id", "")))
	node.add_to_group("persist_3d")
	# Sem cena atual (load a partir de autoload/menu), cai para a raiz da
	# árvore com aviso — nunca dereferencia current_scene nulo.
	var parent: Node = get_tree().current_scene
	if parent == null:
		push_warning("SaveSystem: sem cena atual; restaurando sob a raiz da árvore.")
		parent = get_tree().root
	parent.add_child(node)
	return node

func _slot_path(slot: String) -> String:
	return SAVE_DIR.path_join(slot + ".json")

## SHA-256 da lista de entidades serializada. Adulteração ou truncamento
## muda o resumo e o payload é recusado (com fallback ao .bak no load).
func _checksum(entities: Array) -> String:
	var context := HashingContext.new()
	context.start(HashingContext.HASH_SHA256)
	context.update(JSON.stringify(entities).to_utf8_buffer())
	return context.finish().hex_encode()

## Lê e valida um payload: JSON, versão (com migração) e integridade.
## Retorna dicionário vazio para qualquer inválido — nunca lança.
func _read_valid_payload(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if not (parsed is Dictionary):
		return {}
	var data := parsed as Dictionary
	var version := int(data.get("version", -1))
	if version != FORMAT_VERSION:
		if version < 0 or version > FORMAT_VERSION:
			return {}
		data = migrate_save(data, version)
		if data.is_empty() or int(data.get("version", -1)) != FORMAT_VERSION:
			return {}
	var entities: Variant = data.get("entities", [])
	if not (entities is Array):
		return {}
	if data.has("sha256") and String(data["sha256"]) != _checksum(entities):
		return {}
	return data

## Escreve em .tmp, faz backup do anterior (.bak) e renomeia — queda de
## energia no meio da escrita não destrói o save bom.
func _write_atomic(path: String, payload: Dictionary) -> Error:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(SAVE_DIR))
	var tmp := path + ".tmp"
	var file := FileAccess.open(tmp, FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()
	file.store_string(JSON.stringify(payload, "\t"))
	file.close()
	var global_tmp := ProjectSettings.globalize_path(tmp)
	var global_path := ProjectSettings.globalize_path(path)
	if FileAccess.file_exists(path):
		var bak := global_path + ".bak"
		if FileAccess.file_exists(bak):
			DirAccess.remove_absolute(bak)
		DirAccess.rename_absolute(global_path, bak)
	return DirAccess.rename_absolute(global_tmp, global_path)

## Tipagem explícita de ponta a ponta: inferir (`:=`) a partir de Variant
## gera INFERENCE_ON_VARIANT, que projetos estritos tratam como erro.
func _is_number_array(raw: Variant, expected_size: int) -> bool:
	if not (raw is Array) or raw.size() != expected_size:
		return false
	for value: Variant in raw:
		if not (value is float) and not (value is int):
			return false
	return true

func _vec3_from(raw: Variant) -> Vector3:
	var values := raw as Array
	return Vector3(float(values[0]), float(values[1]), float(values[2]))

func _quat_from(raw: Variant) -> Quaternion:
	var values := raw as Array
	return Quaternion(float(values[0]), float(values[1]), float(values[2]), float(values[3])).normalized()
