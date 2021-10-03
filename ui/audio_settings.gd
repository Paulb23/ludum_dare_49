extends VBoxContainer

var _settin = false

func _ready() -> void:
	_settin = true
	$music_vol.value = GlobalSettings.get_setting("audio/music_vol")
	$sfx_vol.value = GlobalSettings.get_setting("audio/sfx_vol")
	_settin = false

	$music_vol.connect(&"mouse_entered", AudioManager._play_hover)
	$sfx_vol.connect(&"mouse_entered", AudioManager._play_hover)

func _on_music_vol_value_changed(value: float) -> void:
	if not _settin:
		await AudioManager._play_click()
	GlobalSettings.set_setting("audio/music_vol", value)

func _on_sfx_vol_value_changed(value: float) -> void:
	if not _settin:
		await AudioManager._play_click()
	GlobalSettings.set_setting("audio/sfx_vol", value)
