extends SceneTree

## Valida os shaders da skill: carregam como Shader espacial, têm as
## funções esperadas e aceitam ShaderMaterial sem SHADER ERROR no log
## (o runner reprova se "SHADER ERROR" aparecer). Compilação visual com
## GPU/renderizador real está fora do headless — ver tests/README.md.

const EXPECTED := {
	"realistic_water": ["fragment"],
	"realistic_glass": ["fragment"],
	"terrain_blend": ["vertex", "fragment"],
	"foliage_wind": ["vertex", "fragment"],
}

var _failures := 0
var _frames := 0

func _check(label: String, cond: bool, detail: String = "") -> void:
	print(("PASS " if cond else "FAIL ") + label + " " + detail)
	if not cond:
		_failures += 1

func _initialize() -> void:
	for shader_name: String in EXPECTED:
		var path := "res://shaders/" + shader_name + ".gdshader"
		var shader := load(path) as Shader
		_check(shader_name + " carrega", shader != null)
		if shader == null:
			continue
		_check(shader_name + " e espacial", shader.get_mode() == Shader.MODE_SPATIAL)
		for fn: String in EXPECTED[shader_name]:
			_check(shader_name + " tem " + fn + "()", shader.code.contains("void " + fn + "("))
		_check(shader_name + " chaves balanceadas",
			shader.code.count("{") == shader.code.count("}"))
		var material := ShaderMaterial.new()
		material.shader = shader
		var quad := MeshInstance3D.new()
		var mesh := QuadMesh.new()
		quad.mesh = mesh
		quad.material_override = material
		root.add_child(quad)
	process_frame.connect(_finish)

func _finish() -> void:
	_frames += 1
	if _frames < 3:
		return
	process_frame.disconnect(_finish)
	print("SHADERS_DONE failures=", _failures)
	quit(1 if _failures > 0 else 0)
