extends SceneTree

## Verifica o efeito dos sufixos de importação no fixture.glb importado.
## Estrutura impressa com DUMP para diagnóstico; asserts nos efeitos documentados.

var _failures := 0

func _check(label: String, cond: bool, detail: String = "") -> void:
	print(("PASS " if cond else "FAIL ") + label + " " + detail)
	if not cond:
		_failures += 1

func _find(node: Node, node_name: String) -> Node:
	if node.name == node_name:
		return node
	for child: Node in node.get_children():
		var found: Node = _find(child, node_name)
		if found != null:
			return found
	return null

func _has_descendant_of_type(node: Node, type_name: String) -> bool:
	if node.is_class(type_name):
		return true
	for child: Node in node.get_children():
		if _has_descendant_of_type(child, type_name):
			return true
	return false

func _dump(node: Node, depth: int) -> void:
	print("DUMP ", "  ".repeat(depth), node.name, " [", node.get_class(), "]")
	for child: Node in node.get_children():
		_dump(child, depth + 1)

func _initialize() -> void:
	var packed := load("res://assets/fixture.glb") as PackedScene
	_check("glb importa como PackedScene", packed != null)
	if packed == null:
		quit(1)
		return
	var fixture: Node = packed.instantiate()
	_dump(fixture, 0)
	# A importação REMOVE o sufixo do nome: "Wall-col" chega como "Wall".
	var wall: Node = _find(fixture, "Wall")
	_check("Wall (ex -col) presente", wall != null)
	if wall != null:
		_check("-col gera StaticBody3D", _has_descendant_of_type(wall, "StaticBody3D")
			or wall.is_class("StaticBody3D"))
		_check("-col mantem malha", _has_descendant_of_type(wall, "MeshInstance3D")
			or wall.is_class("MeshInstance3D"))
	var ghost: Node = _find(fixture, "Ghost")
	_check("Ghost (ex -colonly) presente", ghost != null)
	if ghost != null:
		_check("-colonly vira StaticBody3D", ghost.is_class("StaticBody3D"))
		_check("-colonly tem CollisionShape3D", _has_descendant_of_type(ghost, "CollisionShape3D"))
		_check("-colonly nao tem malha", not _has_descendant_of_type(ghost, "MeshInstance3D"))
	var shield: Node = _find(fixture, "Shield")
	_check("Shield (ex -occ) presente", shield != null)
	_check("-occ gera OccluderInstance3D na cena", _has_descendant_of_type(fixture, "OccluderInstance3D"))
	var plain: Node = _find(fixture, "Plain")
	_check("Plain sem corpo fisico", plain != null and not _has_descendant_of_type(plain, "StaticBody3D"))
	fixture.free()
	print("IMPORT_DONE failures=", _failures)
	quit(1 if _failures > 0 else 0)
