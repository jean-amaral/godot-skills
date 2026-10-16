extends SceneTree

var _failures := 0
var _frames := 0
var _ramp_prop: Node3D
var _ramp: Node3D

func _check(label: String, cond: bool, detail: String = "") -> void:
	if cond:
		print("PASS ", label, " ", detail)
	else:
		_failures += 1
		printerr("FAIL ", label, " ", detail)

func _box(parent: Node, size: Vector3, pos: Vector3) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = size
	mi.mesh = mesh
	mi.position = pos
	parent.add_child(mi)
	return mi

func _initialize() -> void:
	# Caso A: pai deslocado (10, 5, -3); prop com malha centrada filha.
	var parent_a := Node3D.new()
	parent_a.position = Vector3(10, 5, -3)
	root.add_child(parent_a)
	var prop_a := Node3D.new()
	parent_a.add_child(prop_a)
	_box(prop_a, Vector3(1, 2, 1), Vector3(0, 1, 0))
	var ok_a: bool = PropAligner.snap_to_floor(prop_a, 0.0)
	var aabb_a: AABB = PropAligner.get_global_aabb(prop_a)
	_check("A snap pai-deslocado", ok_a and absf(aabb_a.position.y) < 0.001,
		"base_y=%.4f" % aabb_a.position.y)

	# Caso B: alvo rotacionado 90 graus em Y; place_adjacent_x usa AABB global.
	var ref_b := Node3D.new()
	root.add_child(ref_b)
	_box(ref_b, Vector3(2, 1, 1), Vector3(0, 0.5, 0))
	var tgt_b := Node3D.new()
	tgt_b.position = Vector3(8, 0, 0)
	tgt_b.rotation.y = PI * 0.5
	root.add_child(tgt_b)
	_box(tgt_b, Vector3(2, 1, 1), Vector3(0, 0.5, 0))
	var ok_b: bool = PropAligner.place_adjacent_x(ref_b, tgt_b, 0.25)
	var ref_aabb: AABB = PropAligner.get_global_aabb(ref_b)
	var tgt_aabb: AABB = PropAligner.get_global_aabb(tgt_b)
	var gap_b: float = tgt_aabb.position.x - (ref_aabb.position.x + ref_aabb.size.x)
	_check("B adjacent rotacionado", ok_b and absf(gap_b - 0.25) < 0.001,
		"gap=%.4f tgt_size=%s" % [gap_b, str(tgt_aabb.size)])

	# Caso C: prop escalado 2x (no Node3D, nao em corpo fisico).
	var prop_c := Node3D.new()
	prop_c.position = Vector3(-6, 3, 4)
	prop_c.scale = Vector3(2, 2, 2)
	root.add_child(prop_c)
	_box(prop_c, Vector3.ONE, Vector3(0, 0.5, 0))
	var ok_c: bool = PropAligner.snap_to_floor(prop_c, 1.0)
	var aabb_c: AABB = PropAligner.get_global_aabb(prop_c)
	_check("C snap escalado p/ cota 1.0", ok_c and absf(aabb_c.position.y - 1.0) < 0.001,
		"base_y=%.4f altura_global=%.2f" % [aabb_c.position.y, aabb_c.size.y])

	# Caso D (fisica, frames seguintes): rampa inclinada 30 graus.
	var ramp := StaticBody3D.new()
	ramp.position = Vector3(0, 0, 8)
	ramp.rotation.z = deg_to_rad(30.0)
	root.add_child(ramp)
	var rmi := MeshInstance3D.new()
	var rmesh := BoxMesh.new()
	rmesh.size = Vector3(6, 0.2, 4)
	rmi.mesh = rmesh
	ramp.add_child(rmi)
	var rcs := CollisionShape3D.new()
	var rshape := BoxShape3D.new()
	rshape.size = Vector3(6, 0.2, 4)
	rcs.shape = rshape
	ramp.add_child(rcs)
	_ramp = ramp
	_ramp_prop = Node3D.new()
	_ramp_prop.position = Vector3(0, 3, 8)
	root.add_child(_ramp_prop)
	physics_frame.connect(_on_physics_frame)

func _on_physics_frame() -> void:
	_frames += 1
	if _frames < 3:
		return
	physics_frame.disconnect(_on_physics_frame)
	var space: PhysicsDirectSpaceState3D = root.get_world_3d().direct_space_state
	var ok: bool = PropAligner.place_on_surface(_ramp_prop, space, _ramp_prop.global_position)
	var ramp_normal: Vector3 = _ramp.global_transform.basis.y.normalized()
	var up_dot: float = _ramp_prop.global_transform.basis.y.normalized().dot(ramp_normal)
	_check("D place_on_surface rampa 30deg", ok and up_dot > 0.999,
		"up_dot=%.5f pos=%s" % [up_dot, str(_ramp_prop.global_position)])
	print("ALIGNER_DONE failures=", _failures)
	quit(1 if _failures > 0 else 0)
