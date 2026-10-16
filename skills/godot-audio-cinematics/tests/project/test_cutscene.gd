extends SceneTree

var _failures := 0
var _elapsed := 0.0
var _last_time := 0
var _events: Array[String] = []
var _cutscene: CutscenePlayer
var _phase := 0

func _check(label: String, cond: bool, detail: String = "") -> void:
	print(("PASS " if cond else "FAIL ") + label + " " + detail)
	if not cond:
		_failures += 1

func _initialize() -> void:
	var holder := Node.new()
	holder.name = "Stage"
	root.add_child(holder)
	var player := AnimationPlayer.new()
	player.name = "CutsceneAnim"
	holder.add_child(player)
	_cutscene = CutscenePlayer.new()
	_cutscene.name = "Director"
	holder.add_child(_cutscene)
	_cutscene.animation_player_path = NodePath("../CutsceneAnim")

	var library := AnimationLibrary.new()
	var animation := Animation.new()
	animation.length = 1.0
	var track := animation.add_track(Animation.TYPE_METHOD)
	animation.track_set_path(track, NodePath("Director"))
	animation.track_insert_key(track, 0.4, {"method": &"mark_step", "args": [&"door"]})
	library.add_animation("intro", animation)
	player.add_animation_library("", library)

	_cutscene.started.connect(func(n: StringName) -> void: _events.append("started:" + String(n)))
	_cutscene.step_reached.connect(func(n: StringName) -> void: _events.append("step:" + String(n)))
	_cutscene.finished.connect(_on_finished)
	_last_time = Time.get_ticks_msec()
	process_frame.connect(_tick)

func _on_finished(n: StringName, skipped: bool) -> void:
	_events.append("finished:" + String(n) + ":" + str(skipped))
	if _phase == 0:
		_phase = 1
		_check("caminho normal emite finished", not skipped)
		_cutscene.play(&"intro")
	elif _phase == 1:
		_phase = 2
		_check("pulo emite o mesmo finished", skipped)

func _tick() -> void:
	var now := Time.get_ticks_msec()
	_elapsed += (now - _last_time) / 1000.0
	_last_time = now
	if _phase == 0 and _elapsed > 0.1 and not _cutscene.is_playing():
		_check("play inicia", _cutscene.play(&"intro"))
	if _phase == 1 and _cutscene.is_playing():
		_cutscene.skip()
		_check("skip encerra na hora", not _cutscene.is_playing())
	if _phase == 2:
		_check("ordem dos eventos", _events == [
			"started:intro", "step:door", "finished:intro:false",
			"started:intro", "finished:intro:true"], str(_events))
		_check("skip sem tocar e seguro", _cutscene.is_playing() == false)
		_cutscene.skip()
		print("CUTSCENE_DONE failures=", _failures)
		quit(1 if _failures > 0 else 0)
	if _elapsed > 8.0:
		printerr("FAIL timeout da cutscene de teste; eventos=", _events)
		print("CUTSCENE_DONE failures=99")
		quit(1)
