@tool
extends EditorPlugin

var path: String = get_script().resource_path.get_base_dir() + "/"

func _enter_tree() -> void:
	add_autoload_singleton("GamepadLedManager", path + "gamepad_led_manager.gd")


func _exit_tree() -> void:
	remove_autoload_singleton("GamepadLedManager")
