@tool
class_name ScenePostImport
extends EditorScenePostImport

## Pós-importação de cenas 3D (glTF/.blend) com as regras do projeto.
## Copie para res://scripts/tools/scene_post_import.gd e aponte o asset:
## aba Import → Post Import Script → este arquivo. Depois reimporte.
##
## Convenções aplicadas aqui (o resto é sufixo de nome: -col, -occ, ...):
##   - Malha com nome terminando em "_arch": recebe sombra e entra no
##     pipeline de lightmap (UV2 é gerada nas opções de import da malha).
##   - Nó com nome terminando em "_noshadow": não projeta sombra.

func _post_import(scene: Node) -> Node:
	_apply(scene)
	return scene

func _apply(node: Node) -> void:
	if node is MeshInstance3D:
		var mi := node as MeshInstance3D
		if mi.name.ends_with("_noshadow"):
			mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		elif mi.name.ends_with("_arch"):
			mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	for child: Node in node.get_children():
		_apply(child)
