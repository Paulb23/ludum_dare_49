extends Node3D

var _start_y = 0
var opening = true

func _ready() -> void:
	_start_y = position.y

func open():
	opening = true

func _physics_process(delta: float) -> void:
	if not opening:
		return
	position.y += 5 * delta
	if position.y > _start_y + 5:
		opening = false
		$AnimatableBody3D/CollisionShape3D.disabled = true
