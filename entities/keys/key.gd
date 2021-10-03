extends Node3D

var _blue = Color("#0024ff")
var _purple = Color("#2400c7")
var _yellow = Color("#F4B41B")
var _red = Color("#e60006")

@export_enum("none,blue,purple,yellow,red") var key_colour

func _ready() -> void:
	var cube_mat  = StandardMaterial3D.new()
	var torus_mat  = StandardMaterial3D.new()

	match key_colour:
		1:
			cube_mat.albedo_color = _blue
			torus_mat.albedo_color = _blue
		2:
			cube_mat.albedo_color = _purple
			torus_mat.albedo_color = _purple
		3:
			cube_mat.albedo_color = _yellow
			torus_mat.albedo_color = _yellow
		4:
			cube_mat.albedo_color = _red
			torus_mat.albedo_color = _red

	$Cube.set_surface_override_material(0, cube_mat)
	$Torus.set_surface_override_material(0, torus_mat)

func enable():
	$key/CollisionShape3D.disabled = false
