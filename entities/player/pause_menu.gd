extends VBoxContainer

signal resume

func _ready() -> void:
	$buttons/menu.connect(&"mouse_entered", AudioManager._play_hover)
	$buttons/play.connect(&"mouse_entered", AudioManager._play_hover)
	$buttons/settings.connect(&"mouse_entered", AudioManager._play_hover)
	$buttons/exit.connect(&"mouse_entered", AudioManager._play_hover)

func pre_show():
	await AudioManager._play_click()
	$buttons.visible = true
	$settings.visible = false

func _on_play_pressed() -> void:
	await AudioManager._play_click()
	await resume.emit()

func _on_settings_pressed() -> void:
	await AudioManager._play_click()
	$buttons.visible = false
	$settings.visible = true

func _on_settings_back() -> void:
	$settings.visible = false
	$buttons.visible = true

func _on_exit_pressed() -> void:
	await AudioManager._play_click()
	get_tree().quit()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if not visible:
			await AudioManager._play_click()
			get_parent()._show_pause()
		elif $settings.visible == false:
			await AudioManager._play_click()
			await resume.emit()

func _on_menu_pressed() -> void:
	await AudioManager._play_click()
	get_tree().change_scene("res://ui/main_menu.tscn")
