extends Node


func _ready() -> void:
	var scene = preload("res://audio/music.tscn")
	add_child(scene.instantiate())

func _play_hover():
	$music/button_hover.play()

func _play_click():
	$music/button_click.play()
	await $music/button_click.finished
