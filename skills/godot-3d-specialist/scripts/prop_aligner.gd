@tool
class_name PropAligner
extends Node3D

## Utilitários de alinhamento 3D por AABB global.
## Copie para res://scripts/tools/prop_aligner.gd no projeto.
## O transform global é ACUMULADO à mão pela cadeia de ancestrais, e não lido
## de Node3D.global_transform: fora da árvore (instanciação, _initialize,
## ferramenta headless) global_transform é inválido e retorna identidade,
## o que assentaria o prop no lugar errado sem nenhum erro visível.

## Transform global de `node` acumulado dos ancestrais Node3D.
static func _accumulated_transform(node: Node) -> Transform3D:
	var chain: Array[Transform3D] = []
	var current: Node = node
	while current != null:
		if current is Node3D:
			chain.append((current as Node3D).transform)
		current = current.get_parent()
	chain.reverse()
	var result := Transform3D.IDENTITY
	for t: Transform3D in chain:
		result = result * t
	return result

## Move `node` por `delta` em espaço global, dentro ou fora da árvore.
static func _move_global(node: Node3D, delta: Vector3) -> void:
	if node.is_inside_tree():
		node.global_position += delta
		return
	var parent_xform := Transform3D.IDENTITY
	if node.get_parent() != null:
		parent_xform = _accumulated_transform(node.get_parent())
	var desired_origin: Vector3 = _accumulated_transform(node).origin + delta
	node.position = parent_xform.affine_inverse() * desired_origin

## AABB global combinada de todas as MeshInstance3D sob `node`.
## Retorna AABB vazia (size zero) se não houver malha.
static func get_global_aabb(node: Node) -> AABB:
	var result := AABB()
	var found := false
	if node is MeshInstance3D:
		var mi := node as MeshInstance3D
		if mi.mesh != null:
			result = _accumulated_transform(mi) * mi.get_aabb()
			found = true
	for child: Node in node.get_children():
		var child_aabb := get_global_aabb(child)
		if child_aabb.size == Vector3.ZERO:
			continue
		result = result.merge(child_aabb) if found else child_aabb
		found = true
	return result if found else AABB()

## Assenta `node` sobre a cota `floor_y` pela base da AABB global.
## Retorna false (e não move nada) se o prop não tiver malha.
static func snap_to_floor(node: Node3D, floor_y: float = 0.0) -> bool:
	var aabb := get_global_aabb(node)
	if aabb.size == Vector3.ZERO:
		push_warning("PropAligner: %s sem malha para assentar." % node.name)
		return false
	_move_global(node, Vector3(0.0, floor_y - aabb.position.y, 0.0))
	return true

## Encosta `target` em `reference` no eixo X global, sem sobreposição.
## `gap` negativo nunca é aplicado: sobreposição é sempre erro de chamada.
static func place_adjacent_x(reference: Node3D, target: Node3D, gap: float = 0.0) -> bool:
	var ref_aabb := get_global_aabb(reference)
	var tgt_aabb := get_global_aabb(target)
	if ref_aabb.size == Vector3.ZERO or tgt_aabb.size == Vector3.ZERO:
		push_warning("PropAligner: referência ou alvo sem malha.")
		return false
	var desired_min_x: float = ref_aabb.position.x + ref_aabb.size.x + maxf(gap, 0.0)
	_move_global(target, Vector3(desired_min_x - tgt_aabb.position.x, 0.0, 0.0))
	return true

## Apoia `node` na superfície sob `from_pos` e alinha o "para cima" à normal.
## Exige física ativa (use em _ready/_physics_process ou cena em execução,
## não em cena instanciada fora da árvore). Retorna false sem hit.
static func place_on_surface(node: Node3D, space_state: PhysicsDirectSpaceState3D, from_pos: Vector3, max_dist: float = 50.0) -> bool:
	var query := PhysicsRayQueryParameters3D.create(
		from_pos + Vector3.UP * 2.0,
		from_pos + Vector3.DOWN * max_dist
	)
	if node is CollisionObject3D:
		query.exclude = [(node as CollisionObject3D).get_rid()]
	var hit: Dictionary = space_state.intersect_ray(query)
	if hit.is_empty():
		return false
	var normal: Vector3 = (hit["normal"] as Vector3).normalized()
	var forward: Vector3 = -node.global_transform.basis.z
	forward = (forward - normal * forward.dot(normal))
	if forward.is_zero_approx():
		forward = (Vector3.FORWARD - normal * Vector3.FORWARD.dot(normal))
	forward = forward.normalized()
	# Ordem importa: forward × normal = direita. normal × forward espelha o prop.
	var right: Vector3 = forward.cross(normal).normalized()
	var basis := Basis(right, normal, -forward).orthonormalized()
	node.global_transform = Transform3D(basis, hit["position"] as Vector3)
	return true
