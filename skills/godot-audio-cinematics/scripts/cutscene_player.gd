class_name CutscenePlayer
extends Node

## Tocador de cutscene sobre AnimationPlayer: batidas por sinal e pulo
## seguro (pular = estado final + finished, igual ao caminho normal).
## Copie para res://scripts/cinematics/cutscene_player.gd.
##
## Na animação, marque batidas com uma track de método chamando
## mark_step("nome") neste nó. Quem escuta step_reached aplica o efeito
## (abrir porta, entregar item) — a cutscene não conhece sistema nenhum.

signal started(cutscene_name: StringName)
signal step_reached(step_name: StringName)
signal finished(cutscene_name: StringName, skipped: bool)

@export var animation_player_path: NodePath

var _player: AnimationPlayer
var _current: StringName = &""
var _playing := false

func _ready() -> void:
	_player = get_node_or_null(animation_player_path) as AnimationPlayer
	if _player == null:
		push_warning("CutscenePlayer: AnimationPlayer não encontrado em " + String(animation_player_path))
		return
	_player.animation_finished.connect(_on_animation_finished)

func is_playing() -> bool:
	return _playing

## Toca a cutscene. Retorna false se já houver uma tocando ou sem player.
func play(cutscene_name: StringName) -> bool:
	if _player == null or _playing:
		return false
	if not _player.has_animation(cutscene_name):
		push_warning("CutscenePlayer: animação inexistente: " + String(cutscene_name))
		return false
	_current = cutscene_name
	_playing = true
	started.emit(cutscene_name)
	_player.play(cutscene_name)
	return true

## Chamado por track de método da animação nas batidas importantes.
func mark_step(step_name: StringName) -> void:
	if _playing:
		step_reached.emit(step_name)

## Pula para o estado final: para no fim da animação e emite o MESMO
## finished do caminho normal (com skipped = true). Seguro sem tocar.
func skip() -> void:
	if not _playing or _player == null:
		return
	var animation := _player.get_animation(_current)
	_player.seek(animation.length, true)
	_player.stop()
	_finish(true)

func _on_animation_finished(anim_name: StringName) -> void:
	if _playing and anim_name == _current:
		_finish(false)

func _finish(skipped: bool) -> void:
	_playing = false
	var done := _current
	_current = &""
	finished.emit(done, skipped)
