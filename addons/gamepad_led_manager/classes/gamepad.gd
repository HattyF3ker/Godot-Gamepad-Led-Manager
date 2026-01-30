##A class containing the gamepad properties.
@icon("../icons/gamepad.svg")
class_name Gamepad extends Node

##The id of the gamepad.
var id: int

##The color of the gamepad led.
var color: Color

##The intensity for the color of the gamepad led.
var intensity: float

##The current effect selected for the gamepad led.
var effect: String

##The tweener for this gamepad.
var _tween: Tween = create_tween()

##A previous color used by the turn led on / off functions.
var _previous_color: Color

func _init() -> void:
	name = Input.get_joy_name(id)
