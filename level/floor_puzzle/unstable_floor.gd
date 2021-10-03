extends StaticBody3D

@export_enum("none,air,fire,water,earth") var type
@export var unstable := false

var _fall_speed = 1
var _falling = false

var _start_pos

func _ready() -> void:
	_start_pos = position
	$editor_mesh.hide()
	var model
	match type:
		0:
			model = preload("res://level/floor_puzzle/models/floor_tile_blank.glb")
		1:
			model = preload("res://level/floor_puzzle/models/floor_tile_air.glb")
		2:
			model = preload("res://level/floor_puzzle/models/floor_tile_fire.glb")
		3:
			model = preload("res://level/floor_puzzle/models/floor_tile_water.glb")
		4:
			model = preload("res://level/floor_puzzle/models/floor_tile_earth.glb")
	var instance = model.instantiate()

	var mat = preload("res://base_material.tres")
	instance.get_child(0).set_surface_override_material(0, mat)

	add_child(instance)

func reset_puzzle():
	position = _start_pos
	_falling = false

func _on_area_body_entered(body : Node3D) -> void:
	if unstable and body.name == "player":
		$break.play()
		_falling = true

func _physics_process(delta: float) -> void:
	if not _falling:
		return

	position.y -= _fall_speed

