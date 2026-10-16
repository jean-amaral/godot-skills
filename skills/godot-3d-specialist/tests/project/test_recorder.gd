extends SceneTree

func _initialize() -> void:
	var failures := 0
	# frame_filename usa o nome bruto; a conversão p/ snake_case é do capture_step.
	if DevlogRecorder.frame_filename("cam_main", 7) != "cam_main_step_0007.png":
		failures += 1
		printerr("FAIL recorder filename cam_main")
	else:
		print("PASS recorder filename cam_main")
	if DevlogRecorder.frame_filename("cam_main", 0) != "cam_main_step_0000.png":
		failures += 1
		printerr("FAIL recorder filename step 0")
	else:
		print("PASS recorder filename step 0")
	if DevlogRecorder.OUTPUT_DIR != "res://devlog/screenshots":
		failures += 1

	# Coleta: filhas de DevlogCameras + grupo, sem duplicar quem tem os dois.
	var holder := Node3D.new()
	holder.name = "Level"
	root.add_child(holder)
	var devlog_node := Node3D.new()
	devlog_node.name = "DevlogCameras"
	holder.add_child(devlog_node)
	var cam_a := Camera3D.new()
	cam_a.name = "cam_main"
	devlog_node.add_child(cam_a)
	var cam_b := Camera3D.new()
	cam_b.name = "cam_detail"
	cam_b.add_to_group("devlog_cameras")
	devlog_node.add_child(cam_b)
	var cam_c := Camera3D.new()
	cam_c.name = "cam_loose"
	cam_c.add_to_group("devlog_cameras")
	holder.add_child(cam_c)
	var cam_out := Camera3D.new()
	cam_out.name = "game_cam"
	holder.add_child(cam_out)
	var found := DevlogRecorder.find_cameras(holder)
	if found.size() == 3 and found.has(cam_a) and found.has(cam_b) and found.has(cam_c):
		print("PASS recorder coleta DevlogCameras+grupo sem duplicar")
	else:
		failures += 1
		printerr("FAIL recorder coleta: ", found.size(), " cameras")

	print("RECORDER_DONE failures=", failures)
	quit(1 if failures > 0 else 0)
