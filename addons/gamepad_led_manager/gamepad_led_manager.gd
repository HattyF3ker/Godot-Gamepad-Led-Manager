##The manager for the gamepads led.
extends Node

##The folder where is located the gamepads effects.
const EFFECTS_FOLDER = "res://addons/gamepad_led_manager/effects/"

##If is enabled, every gamepad connected will pick a random color on the default_colors array.
##Else, it will be in connection order from the default_colors array.
var random_default_colors: bool = true

var default_colors: Array[Color] = [
	Color.BLUE,
	Color.RED,
	Color.GREEN,
	Color.PURPLE,
	Color.ORANGE_RED,
	Color.CYAN,
	Color.PINK,
	Color.MAROON
]

var gamepads: Array[Gamepad]

func _init() -> void:
	Input.joy_connection_changed.connect(_manage_gamepad_connection)

##Manages the gamepads connections.
func _manage_gamepad_connection(device: int, connected: bool):
	if not connected:
		if get_gamepad(device).id == device:
			gamepads.erase(get_gamepad(device))
	else:
		var gamepad: Gamepad = Gamepad.new()
		gamepad.id = device
		gamepad.intensity = 1.0
		var color: Color
		if random_default_colors: color = default_colors[randi_range(0, default_colors.size() - 1)]
		else: color = default_colors[device]
		gamepads.append(gamepad)
		set_led_color(device, color)

##Get the selected gamepad.
func get_gamepad(device: int) -> Variant:
	for i in gamepads:
		if i.id == device:
			return i
	return null

##Gets the selected gamepad led color.
func get_led_color(device: int) -> Color:
	if get_gamepad(device) != null:
		return get_gamepad(device).color
	return Color.BLACK

##Gets the selected gamepad led color intensity.
func get_led_intensity(device: int) -> float:
	if get_gamepad(device) != null:
		return get_gamepad(device).intensity
	return 1.0

##Changes the gamepad led color and intensity.
func set_led_color(device: int, color: Color = Color.WHITE, use_intensity: bool = true, intensity: float = 1.0):
	var gamepad: Gamepad = get_gamepad(device)
	if gamepad != null:
		var final_color: Color
		if use_intensity: final_color = color.srgb_to_linear() * (2 * intensity)
		else: final_color = color
		if Input.has_joy_light(device):
			Input.set_joy_light(device, final_color)
			gamepad.color = final_color
			gamepad.intensity = intensity

##Set led color function but with an array as an parameter.
func set_led_color_array(arguments: Array):
	var device: int = arguments.get(0)
	var color: Color = arguments.get(1)
	var use_intensity: bool = arguments.get(2)
	var intensity: float = arguments.get(3)
	set_led_color(device, color, use_intensity, intensity)

##Makes a tween for the gamepad led color and intensity.
func tween_led_color(device: int, color: Color, use_intensity: bool, intensity: float, duration: float, ease: Tween.EaseType = Tween.EASE_IN_OUT, transition: Tween.TransitionType = Tween.TRANS_CUBIC) -> Variant:
	var gamepad: Gamepad = get_gamepad(device)
	if gamepad != null:
		gamepad._tween.stop()
		var tween: Tween = create_tween()
		gamepad._tween = tween
		await tween.tween_method(set_led_color_array, [device, gamepad.color, use_intensity, gamepad.intensity], [device, color, use_intensity, intensity], duration).set_ease(ease).set_trans(transition).finished
		return
	return

##Turns a gamepad led on.
func turn_led_on(device: int) -> void:
	var gamepad: Gamepad = get_gamepad(device)
	set_led_color(device, gamepad._previous_color, false)

##Turns a gamepad led off.
func turn_led_off(device: int) -> void:
	var gamepad: Gamepad = get_gamepad(device)
	if get_led_color(device) != Color.BLACK:
		gamepad._previous_color = get_led_color(device)
	remove_effect(device)
	set_led_color(device, Color.BLACK, false)

##Sets a gamepad effect from effects folder.
func set_effect(device: int, effect: String, arguments: Dictionary = {}):
	var gamepad: Gamepad = get_gamepad(device)
	var loaded_effect: GamepadEffect = load(EFFECTS_FOLDER + effect + ".gd").new()
	gamepad.effect = effect
	loaded_effect.device = gamepad.id
	loaded_effect.color = gamepad.color
	loaded_effect.intensity = gamepad.intensity
	loaded_effect.arguments = arguments
	remove_effect(device)
	add_child(loaded_effect)

##Removes the current aplied effect for the selected gamepad.
func remove_effect(device: int) -> void:
	var gamepad: Gamepad = get_gamepad(device)
	for i in get_children():
		if i.device == device:
			gamepad._tween.stop()
			gamepad.effect = ""
			i.remove()
