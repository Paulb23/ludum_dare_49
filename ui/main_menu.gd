extends Control

func _ready() -> void:
	$VBoxContainer/play.connect(&"mouse_entered", AudioManager._play_hover)
	$VBoxContainer/settings.connect(&"mouse_entered", AudioManager._play_hover)
	$VBoxContainer/exit.connect(&"mouse_entered", AudioManager._play_hover)

func _on_play_pressed() -> void:
	await AudioManager._play_click()
	get_tree().change_scene("res://level/main_level.tscn")

func _on_settings_pressed() -> void:
	await $settings.pre_show()
	$VBoxContainer.visible = false
	$settings.visible = true

func _on_exit_pressed() -> void:
	await AudioManager._play_click()
	get_tree().quit()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if $settings.visible:
			_on_settings_back()
			accept_event()

func _on_settings_back() -> void:
	$settings.visible = false
	$VBoxContainer.visible = true
