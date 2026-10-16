class_name SaveTestEntity
extends Node3D

var is_open := false

func get_save_state() -> Dictionary:
	return {"open": is_open}

func apply_save_state(state: Dictionary) -> void:
	is_open = bool(state.get("open", false))
