extends Control

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_Timer_timeout() -> void:
	get_tree().change_scene("res://ui/main_menu.tscn")
