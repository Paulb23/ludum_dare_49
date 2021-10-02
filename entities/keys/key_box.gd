extends Node3D

@export_enum("none,blue,purple,yellow,red") var key_colour

@onready var animation = $AnimationPlayer

func open():
	if key_colour == 1:
		animation.play("open")

func _on_AnimationPlayer_animation_finished(anim_name: StringName) -> void:
	$keybox.input_ray_pickable = false
	$keybox.queue_free()
