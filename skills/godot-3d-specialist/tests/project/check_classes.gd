extends SceneTree

## Imprime CLASS_EXISTS <nome>=true/false para os argumentos após --.
## Usado pela matriz de versões: rode com cada Godot e compare a saída.

func _initialize() -> void:
	print("ENGINE ", Engine.get_version_info().get("string", "?"))
	for arg: String in OS.get_cmdline_user_args():
		print("CLASS_EXISTS ", arg, "=", ClassDB.class_exists(arg))
	quit(0)
