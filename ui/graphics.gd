extends VBoxContainer

var _settin = false

func _ready() -> void:
	_settin = true
	$fov.value = GlobalSettings.get_setting("graphics/fov")
	$window_mode. selected = GlobalSettings.get_setting("graphics/window_mode")
	_settin = false

	$back.connect(&"mouse_entered", AudioManager._play_hover)
	$fov.connect(&"mouse_entered", AudioManager._play_hover)
	$window_mode.connect(&"mouse_entered", AudioManager._play_hover)

func _on_fov_value_changed(value: float) -> void:
	if not _settin:
		await AudioManager._play_click()
	GlobalSettings.set_setting("graphics/fov", value)


func _on_window_mode_item_selected(index: int) -> void:
	if not _settin:
		await AudioManager._play_click()
	GlobalSettings.set_setting("graphics/window_mode", index)
