extends Control

var selected: int

func _ready() -> void:
	Input.joy_connection_changed.connect(_on_joy_connection)

func _on_joy_connection(device: int, connected: bool) -> void:
	if connected:
		$GamepadSelector.get_popup().add_item(GamepadLedManager.get_gamepad(device).name, device)
		$GamepadSelector.select(device)
	else:
		$GamepadSelector.select(device - 1)
		$GamepadSelector.get_popup().remove_item(device)

func _process(_delta: float) -> void:
	$LedColor.color = GamepadLedManager.get_led_color(selected)
	$CurrentLedColor.text = "Current Led Color: " + str(GamepadLedManager.get_led_color(selected))
	if GamepadLedManager.get_gamepad(selected) != null:
		$SelectedGamepad.text = "Selected Gamepad: " + GamepadLedManager.get_gamepad(0).name + " | ID: " + str(GamepadLedManager.get_gamepad(selected).id)
		$HasLed.text = "Has Led: " + str(Input.has_joy_light(selected)).capitalize()

func _on_button_pressed() -> void:
	GamepadLedManager.turn_led_on(selected)

func _off_button_pressed() -> void:
	GamepadLedManager.turn_led_off(selected)

func _r_on_button_pressed() -> void:
	GamepadLedManager.set_effect(selected, "rainbow")

func _p_on_button_pressed() -> void:
	##This have optional arguments, check "res://addons/gamepad_led_manager/effects/pulse.gd".
	GamepadLedManager.set_effect(selected, "pulse", {"transition": Tween.TRANS_LINEAR, "loop": false})

func _r_off_button_pressed() -> void:
	GamepadLedManager.remove_effect(selected)

func _on_color_picker_color_changed(color: Color) -> void:
	GamepadLedManager.set_led_color(selected, color, false)

func _on_gamepad_selector_item_selected(index: int) -> void:
	selected = index
