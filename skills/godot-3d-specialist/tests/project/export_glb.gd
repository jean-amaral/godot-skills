extends SceneTree

## Gera res://assets/fixture.glb com malhas nomeadas pelos sufixos de importação.

func _mesh_node(node_name: String, pos: Vector3) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	mi.name = node_name
	var mesh := BoxMesh.new()
	mesh.size = Vector3.ONE
	mi.mesh = mesh
	mi.position = pos
	return mi

func _initialize() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://assets"))
	var fixture_root := Node3D.new()
	fixture_root.name = "Fixture"
	fixture_root.add_child(_mesh_node("Wall-col", Vector3.ZERO))
	fixture_root.add_child(_mesh_node("Ghost-colonly", Vector3(2, 0, 0)))
	fixture_root.add_child(_mesh_node("Shield-occ", Vector3(4, 0, 0)))
	fixture_root.add_child(_mesh_node("Plain", Vector3(6, 0, 0)))
	var doc := GLTFDocument.new()
	var state := GLTFState.new()
	var err := doc.append_from_scene(fixture_root, state)
	if err != OK:
		printerr("GLB append falhou: ", err)
		quit(1)
		return
	err = doc.write_to_filesystem(state, "res://assets/fixture.glb")
	print("GLB_WRITE err=", err)
	fixture_root.free()
	quit(0 if err == OK else 1)
