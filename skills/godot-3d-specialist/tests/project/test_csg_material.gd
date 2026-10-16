extends SceneTree

var _failures := 0
var _frames := 0
var _combiner: CSGCombiner3D

func _check(label: String, cond: bool, detail: String = "") -> void:
	print(("PASS " if cond else "FAIL ") + label + " " + detail)
	if not cond:
		_failures += 1

func _initialize() -> void:
	# Parede 4x3x0.2 com vão de porta por subtração (receita da referência).
	_combiner = CSGCombiner3D.new()
	_combiner.name = "Room"
	root.add_child(_combiner)
	var wall := CSGBox3D.new()
	wall.name = "Wall"
	wall.size = Vector3(4, 3, 0.2)
	wall.position = Vector3(0, 1.5, 0)
	_combiner.add_child(wall)
	var door := CSGBox3D.new()
	door.name = "DoorCut"
	door.operation = CSGShape3D.OPERATION_SUBTRACTION
	door.size = Vector3(1.0, 2.1, 0.24)
	door.position = Vector3(0, 1.05, 0)
	_combiner.add_child(door)
	process_frame.connect(_run)

func _run() -> void:
	_frames += 1
	if _frames < 3:
		return
	process_frame.disconnect(_run)

	var baked := CsgBaker.bake_to_mesh_instance(_combiner, _combiner.get_parent(), "WallBaked", true)
	_check("bake devolve MeshInstance3D", baked != null)
	if baked != null:
		var aabb := baked.mesh.get_aabb()
		_check("AABB da parede assada", absf(aabb.size.x - 4.0) < 0.01
			and absf(aabb.size.y - 3.0) < 0.01, str(aabb.size))
		var has_body := false
		var has_shape := false
		for child: Node in baked.get_children():
			if child is StaticBody3D:
				has_body = true
				for sub: Node in child.get_children():
					if sub is CollisionShape3D and (sub as CollisionShape3D).shape != null:
						has_shape = true
		_check("bake cria corpo+forma de colisao", has_body and has_shape)

	# --- Material PBR a partir de mapas gerados (texturas de teste) ---
	var albedo := _solid_texture(Color(0.6, 0.45, 0.3))
	var roughness := _solid_texture(Color(0.0, 0.8, 0.0))
	var mat := PbrMaterialBuilder.create_material(albedo, null, roughness, null, 0.5, true)
	_check("material com albedo", mat.albedo_texture == albedo)
	_check("roughness no canal G", mat.roughness_texture == roughness
		and mat.roughness_texture_channel == BaseMaterial3D.TEXTURE_CHANNEL_GREEN)
	_check("uv scale e triplanar", mat.uv1_scale == Vector3(0.5, 0.5, 1.0) and mat.uv1_triplanar)
	_check("salva .tres", PbrMaterialBuilder.save_material(mat, "res://generated/wall_material.tres") == OK)
	var loaded := load("res://generated/wall_material.tres") as StandardMaterial3D
	# Recarregar cria outra instancia de recurso: compara presenca, nao identidade.
	_check(".tres carrega como StandardMaterial3D", loaded != null
		and loaded.albedo_texture != null and loaded.uv1_triplanar)

	print("CSG_MATERIAL_DONE failures=", _failures)
	quit(1 if _failures > 0 else 0)

func _solid_texture(color: Color) -> ImageTexture:
	var image := Image.create(8, 8, false, Image.FORMAT_RGBA8)
	image.fill(color)
	return ImageTexture.create_from_image(image)
