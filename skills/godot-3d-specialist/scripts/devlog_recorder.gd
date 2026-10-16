@tool
class_name DevlogRecorder
extends Node

## Captura screenshots numerados das câmeras de devlog.
## Copie para res://scripts/tools/devlog_recorder.gd e adicione como filho
## da cena do nível (ou chame capture_step() do seu fluxo de devlog).
## Câmeras aceitas (os dois jeitos, sem duplicar): Camera3D filhas de um nó
## chamado "DevlogCameras" OU qualquer Camera3D no grupo "devlog_cameras".
##
## Regra de ouro: NÃO mova as câmeras entre capturas — mesmo transform e fov
## em todas as etapas, ou o antes/depois e o timelapse perdem o alinhamento.
## Captura real exige renderização (não use --headless: o frame sai vazio).

const OUTPUT_DIR := "res://devlog/screenshots"
const CAMERA_GROUP := "devlog_cameras"

## Nome determinístico do frame: cam_main_step_0007.png
static func frame_filename(camera_name: String, step: int) -> String:
	return "%s_step_%04d.png" % [camera_name, step]

## Coleta as câmeras de devlog sob `root_node`, sem duplicar quem satisfaz
## os dois critérios (filha de DevlogCameras e membro do grupo).
static func find_cameras(root_node: Node) -> Array[Camera3D]:
	var found: Array[Camera3D] = []
	_collect_cameras(root_node, false, found)
	return found

static func _collect_cameras(node: Node, under_devlog_node: bool, found: Array[Camera3D]) -> void:
	var inside: bool = under_devlog_node or node.name == "DevlogCameras"
	if node is Camera3D and (inside or node.is_in_group(CAMERA_GROUP)):
		var camera := node as Camera3D
		if not found.has(camera):
			found.append(camera)
	for child: Node in node.get_children():
		_collect_cameras(child, inside, found)

## Captura um frame de cada câmera de devlog para a etapa `step`.
## Retorna quantos arquivos foram gravados (0 com aviso se não houver câmera).
func capture_step(step: int) -> int:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUTPUT_DIR))
	var cameras := find_cameras(get_tree().root)
	if cameras.is_empty():
		push_warning("DevlogRecorder: nenhuma câmera de devlog (nó DevlogCameras ou grupo '"
			+ CAMERA_GROUP + "'). Nada capturado.")
		return 0
	var saved := 0
	for camera: Camera3D in cameras:
		var previous: Camera3D = get_viewport().get_camera_3d()
		camera.current = true
		await RenderingServer.frame_post_draw
		var image: Image = get_viewport().get_texture().get_image()
		if previous != null and previous != camera:
			previous.current = true
		if image.is_empty():
			push_warning("DevlogRecorder: frame vazio de %s (renderização headless?)." % camera.name)
			continue
		var path := OUTPUT_DIR.path_join(frame_filename(camera.name.to_snake_case(), step))
		if image.save_png(path) == OK:
			saved += 1
	return saved
