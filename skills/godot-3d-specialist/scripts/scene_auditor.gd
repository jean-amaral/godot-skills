class_name SceneAuditor
extends SceneTree

## Auditor estrutural headless de cenas 3D (configurável, multi-cena).
## Copie para res://scripts/tools/scene_auditor.gd no projeto.
##
## Uso:
##   godot --headless --script res://scripts/tools/scene_auditor.gd -- res://a.tscn res://b.tscn
##   godot --headless --script res://scripts/tools/scene_auditor.gd -- --config=res://audit_config.json res://a.tscn
## Sem cena, audita res://scenes/environments/main_level.tscn.
## Saída: res://devlog/audit_report.json; exit 1 se houver erro, 0 caso contrário.
##
## audit_config.json (opcional):
##   {
##     "ignore_types": ["DUPLICATE_NODE_NAME"],
##     "ignore": [{"type": "FLOATING_PROP", "node_prefix": "/Main/Decor"}],
##     "max_lights": 12,
##     "max_texture_size": 2048
##   }
##
## A auditoria é estrutural: a cena é instanciada FORA da árvore, então
## _ready/física não rodam. Transform global é acumulado à mão na recursão.

const DEFAULT_SCENE := "res://scenes/environments/main_level.tscn"
const REPORT_PATH := "res://devlog/audit_report.json"
const FLOOR_TOLERANCE := 0.001

var _ignore_types: Array[String] = []
var _ignore_rules: Array[Dictionary] = []
var _max_lights := -1
var _max_texture_size := 0
var _light_count := 0

func _initialize() -> void:
	var scene_paths: Array[String] = []
	var report_path := REPORT_PATH
	var args := OS.get_cmdline_user_args()
	var i := 0
	while i < args.size():
		var arg := args[i]
		if arg.begins_with("--config="):
			_load_config(arg.trim_prefix("--config="))
		elif arg.begins_with("--report="):
			report_path = arg.trim_prefix("--report=")
		elif arg.ends_with(".tscn"):
			scene_paths.append(arg)
		i += 1
	if scene_paths.is_empty():
		scene_paths.append(DEFAULT_SCENE)

	var all_issues: Array[Dictionary] = []
	var scene_reports: Array[Dictionary] = []
	var total_errors := 0
	var failed := false
	for scene_path: String in scene_paths:
		var packed := load(scene_path) as PackedScene
		if packed == null:
			printerr("SceneAuditor: cena inválida: ", scene_path)
			failed = true
			continue
		_light_count = 0
		var root_node: Node = packed.instantiate()
		var root_name := root_node.name
		var issues: Array[Dictionary] = []
		_audit(root_node, "/" + root_name, Transform3D.IDENTITY, issues)
		root_node.free()
		if _max_lights >= 0 and _light_count > _max_lights:
			issues.append({"node": "/" + root_name, "type": "TOO_MANY_LIGHTS",
				"severity": "warning",
				"detail": "%d luzes (limite do projeto: %d)" % [_light_count, _max_lights]})
		issues = _filtered(issues)
		var errors := 0
		for issue: Dictionary in issues:
			issue["scene"] = scene_path
			if issue["severity"] == "error":
				errors += 1
		total_errors += errors
		all_issues.append_array(issues)
		scene_reports.append({"scene": scene_path, "error_count": errors,
			"issue_count": issues.size(), "issues": issues})
		print("SceneAuditor: %d erro(s), %d issue(s) em %s" % [errors, issues.size(), scene_path])

	DirAccess.make_dir_recursive_absolute(
		ProjectSettings.globalize_path(report_path.get_base_dir()))
	var file := FileAccess.open(report_path, FileAccess.WRITE)
	if file != null:
		file.store_string(JSON.stringify({
			"scene": scene_paths[0],
			"timestamp": Time.get_datetime_string_from_system(),
			"error_count": total_errors,
			"issue_count": all_issues.size(),
			"issues": all_issues,
			"scenes": scene_reports,
		}, "\t"))
		file.close()
	quit(1 if (failed or total_errors > 0) else 0)

func _load_config(path: String) -> void:
	if not FileAccess.file_exists(path):
		printerr("SceneAuditor: config não encontrada: ", path)
		return
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
	if not (parsed is Dictionary):
		printerr("SceneAuditor: config inválida (JSON esperado): ", path)
		return
	var cfg := parsed as Dictionary
	for t: Variant in cfg.get("ignore_types", []):
		_ignore_types.append(String(t))
	for r: Variant in cfg.get("ignore", []):
		if r is Dictionary:
			_ignore_rules.append(r)
	_max_lights = int(cfg.get("max_lights", -1))
	_max_texture_size = int(cfg.get("max_texture_size", 0))

func _filtered(issues: Array[Dictionary]) -> Array[Dictionary]:
	var kept: Array[Dictionary] = []
	for issue: Dictionary in issues:
		var type := String(issue["type"])
		if _ignore_types.has(type):
			continue
		var ignored := false
		for rule: Dictionary in _ignore_rules:
			if String(rule.get("type", "")) == type \
					and String(issue["node"]).begins_with(String(rule.get("node_prefix", ""))):
				ignored = true
		if not ignored:
			kept.append(issue)
	return kept

func _audit(node: Node, path: String, parent_global: Transform3D, issues: Array[Dictionary]) -> void:
	var global_xform := parent_global
	if node is Node3D:
		global_xform = parent_global * (node as Node3D).transform

	if node is Light3D:
		_light_count += 1

	if node is CollisionObject3D:
		var body := node as Node3D
		var s: Vector3 = body.scale
		if not s.is_equal_approx(Vector3.ONE):
			var uniform: bool = is_equal_approx(s.x, s.y) and is_equal_approx(s.y, s.z)
			issues.append({
				"node": path,
				"type": "SCALED_PHYSICS_BODY" if uniform else "NON_UNIFORM_SCALE",
				"severity": "warning" if uniform else "error",
				"detail": "scale %s em corpo físico; redimensione a Shape3D" % str(s),
			})
		var has_shape := false
		for child: Node in node.get_children():
			if child is CollisionShape3D and (child as CollisionShape3D).shape != null:
				has_shape = true
		if not has_shape:
			issues.append({"node": path, "type": "MISSING_COLLISION_SHAPE",
				"severity": "error", "detail": "Corpo físico sem CollisionShape3D válido"})

	if node is MeshInstance3D:
		var mi := node as MeshInstance3D
		if mi.mesh == null:
			issues.append({"node": path, "type": "EMPTY_MESH_INSTANCE",
				"severity": "warning", "detail": "MeshInstance3D sem mesh"})
		elif _max_texture_size > 0:
			_check_textures(mi, path, issues)

	if node.is_in_group("floor_props") and node is Node3D:
		var aabb := _first_mesh_global_aabb(node, global_xform)
		if aabb.size != Vector3.ZERO and absf(aabb.position.y) > FLOOR_TOLERANCE:
			issues.append({"node": path, "type": "FLOATING_PROP", "severity": "warning",
				"detail": "Base da AABB em Y=%.4f (esperado 0)" % aabb.position.y})

	var seen_names: Dictionary[String, bool] = {}
	for child: Node in node.get_children():
		if seen_names.has(child.name):
			issues.append({"node": path + "/" + child.name, "type": "DUPLICATE_NODE_NAME",
				"severity": "warning", "detail": "Irmãos com o mesmo nome quebram $Caminho"})
		seen_names[child.name] = true
		_audit(child, path + "/" + child.name, global_xform, issues)

func _check_textures(mi: MeshInstance3D, path: String, issues: Array[Dictionary]) -> void:
	for surface: int in mi.mesh.get_surface_count():
		var mat := mi.mesh.surface_get_material(surface) as BaseMaterial3D
		if mat == null or mat.albedo_texture == null:
			continue
		var size: Vector2i = mat.albedo_texture.get_size()
		if size.x > _max_texture_size or size.y > _max_texture_size:
			issues.append({"node": path, "type": "TEXTURE_TOO_LARGE", "severity": "warning",
				"detail": "Textura %s %dx%d (limite: %d)" % [mat.albedo_texture.resource_path, size.x, size.y, _max_texture_size]})
			return

func _first_mesh_global_aabb(node: Node, global_xform: Transform3D) -> AABB:
	if node is MeshInstance3D:
		var mi := node as MeshInstance3D
		if mi.mesh != null:
			return global_xform * mi.get_aabb()
	for child: Node in node.get_children():
		var child_global := global_xform
		if child is Node3D:
			child_global = global_xform * (child as Node3D).transform
		var aabb := _first_mesh_global_aabb(child, child_global)
		if aabb.size != Vector3.ZERO:
			return aabb
	return AABB()
