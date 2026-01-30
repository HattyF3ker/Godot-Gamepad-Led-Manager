##A simple class that contains the base for Gamepad Effects.
@icon("../icons/gamepad_effect.svg")
class_name GamepadEffect extends Node

var device: int
var color: Color
var intensity: float

var arguments: Dictionary

func _process(delta: float) -> void:
	if GamepadLedManager.get_gamepad(device) == null: return

func remove():
	queue_free()
