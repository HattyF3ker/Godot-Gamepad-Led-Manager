extends GamepadEffect

var previous_color: Color

func _ready() -> void:
	var color: Color = arguments.get("color", Color.BLACK)
	var loop: bool = arguments.get("loop", true)
	var loop_time: float = arguments.get("loop_time", 2.25)
	var duration: float = arguments.get("duration", 2.25)
	var ease: Tween.EaseType = arguments.get("ease", Tween.EASE_IN_OUT)
	var transition: Tween.TransitionType = arguments.get("transition", Tween.TRANS_LINEAR)
	pulse(color, loop, loop_time, duration, ease, transition)

func pulse(color: Color, loop: bool, loop_time: float, duration: float, ease: Tween.EaseType, transition: Tween.TransitionType) -> void:
	previous_color = GamepadLedManager.get_led_color(device)
	await GamepadLedManager.tween_led_color(device, color, false, 1, duration * 0.5, ease, transition)
	await GamepadLedManager.tween_led_color(device, previous_color, false, 1, duration * 0.5, ease, transition)
	await get_tree().create_timer(2.25).timeout
	if loop: pulse(color, loop, loop_time, duration, ease, transition)
	else: remove()
