extends SceneTree

## Gera as cenas-fixture do auditor em res://scenes/.
## Grupos de cena usam persistent=true: add_to_group() comum não é salvo no .tscn.

func _set_owners(node: Node, owner_root: Node) -> void:
	for child: Node in node.get_children():
		child.owner = owner_root
		_set_owners(child, owner_root)

func _box_mesh(size: Vector3) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = size
	mi.mesh = mesh
	return mi

func _body(with_shape: bool) -> StaticBody3D:
	var body := StaticBody3D.new()
	body.name = "Body"
	var mi := _box_mesh(Vector3(2, 3, 0.2))
	mi.name = "WallMesh"
	mi.position.y = 1.5
	body.add_child(mi)
	if with_shape:
		var cs := CollisionShape3D.new()
		cs.name = "Shape"
		var shape := BoxShape3D.new()
		shape.size = Vector3(2, 3, 0.2)
		cs.shape = shape
		cs.position.y = 1.5
		body.add_child(cs)
	return body

func _save(root_node: Node, path: String) -> void:
	_set_owners(root_node, root_node)
	var packed := PackedScene.new()
	if packed.pack(root_node) != OK:
		printerr("GEN_FAIL pack ", path)
		return
	print("GEN ", path, " err=", ResourceSaver.save(packed, path))
	root_node.free()

func _initialize() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://scenes"))

	var valid := Node3D.new()
	valid.name = "Main"
	valid.add_child(_body(true))
	var crate := Node3D.new()
	crate.name = "Crate"
	crate.add_to_group("floor_props", true)
	var cm := _box_mesh(Vector3.ONE)
	cm.name = "CrateMesh"
	cm.position.y = 0.5
	crate.add_child(cm)
	valid.add_child(crate)
	_save(valid, "res://scenes/valid.tscn")

	var nu := Node3D.new()
	nu.name = "Main"
	var nub := _body(true)
	nub.scale = Vector3(2, 1, 0.5)
	nu.add_child(nub)
	_save(nu, "res://scenes/nonuniform.tscn")

	var us := Node3D.new()
	us.name = "Main"
	var usb := _body(true)
	usb.scale = Vector3(2, 2, 2)
	us.add_child(usb)
	_save(us, "res://scenes/uniform.tscn")

	var missing := Node3D.new()
	missing.name = "Main"
	missing.add_child(_body(false))
	_save(missing, "res://scenes/missing_shape.tscn")

	var fl := Node3D.new()
	fl.name = "Main"
	var fp := Node3D.new()
	fp.name = "FloatingCrate"
	fp.add_to_group("floor_props", true)
	var fm := _box_mesh(Vector3.ONE)
	fm.name = "Mesh"
	fm.position.y = 2.5
	fp.add_child(fm)
	fl.add_child(fp)
	_save(fl, "res://scenes/floating.tscn")

	var em := Node3D.new()
	em.name = "Main"
	var emi := MeshInstance3D.new()
	emi.name = "EmptyMesh"
	em.add_child(emi)
	_save(em, "res://scenes/empty_mesh.tscn")

	var ml := Node3D.new()
	ml.name = "Main"
	for n: int in 3:
		var light := OmniLight3D.new()
		light.name = "Light%d" % n
		light.position = Vector3(n * 2, 2, 0)
		ml.add_child(light)
	_save(ml, "res://scenes/many_lights.tscn")

	quit(0)
