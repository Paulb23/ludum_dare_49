extends Control

signal back

func _ready() -> void:
	$"VBoxContainer/graphics".connect(&"mouse_entered", AudioManager._play_hover)
	$"VBoxContainer/controls".connect(&"mouse_entered", AudioManager._play_hover)
	$"VBoxContainer/audio".connect(&"mouse_entered", AudioManager._play_hover)
	$"VBoxContainer/back".connect(&"mouse_entered", AudioManager._play_hover)

func pre_show() -> void:
	await AudioManager._play_click()
	$graphics.visible = false
	$controls.visible = false
	$audio.visible = false
	$VBoxContainer.visible = true

func _on_graphics_pressed() -> void:
	await AudioManager._play_click()
	$graphics.visible = true
	$controls.visible = false
	$audio.visible = false
	$VBoxContainer.visible = false

func _on_controls_pressed() -> void:
	await AudioManager._play_click()
	$graphics.visible = false
	$controls.visible = true
	$audio.visible = false
	$VBoxContainer.visible = false

func _on_audio_pressed() -> void:
	await AudioManager._play_click()
	$graphics.visible = false
	$controls.visible = false
	$audio.visible = true
	$VBoxContainer.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if visible and Input.is_action_just_pressed("ui_cancel"):
		if $VBoxContainer.visible:
			await AudioManager._play_click()
			GlobalSettings.save()
			back.emit()
			accept_event()
		elif $graphics.visible || $controls.visible || $audio.visible:
			await pre_show()
			accept_event()

func _on_back_pressed() -> void:
	await AudioManager._play_click()
	GlobalSettings.save()
	back.emit()
