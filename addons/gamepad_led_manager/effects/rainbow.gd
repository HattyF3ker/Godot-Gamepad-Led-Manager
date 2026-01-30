extends GamepadEffect

var hue: float

func _process(delta: float) -> void:
	super._process(delta)
	hue += 0.15 * delta
	GamepadLedManager.set_led_color(device, Color.from_hsv(hue, 1, 1))
