extends VBoxContainer

var _settin = false

func _ready() -> void:
	_settin = true
	$invery_y.pressed = GlobalSettings.get_setting("controls/invert_y")
	$mouse_sens.value = GlobalSettings.get_setting("controls/mouse_sensitvity")
	_settin = false

	$invery_y.connect(&"mouse_entered", AudioManager._play_hover)
	$mouse_sens.connect(&"mouse_entered", AudioManager._play_hover)
	$back.connect(&"mouse_entered", AudioManager._play_hover)

func _on_invery_y_toggled(button_pressed: bool) -> void:
	if not _settin:
		await AudioManager._play_click()
	GlobalSettings.set_setting("controls/invert_y", button_pressed)

func _on_mouse_sens_value_changed(value: float) -> void:
	if not _settin:
		await AudioManager._play_click()
	GlobalSettings.set_setting("controls/mouse_sensitvity", value)

