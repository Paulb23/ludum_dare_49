extends Node3D

var _blue = Color("#28CCDF")
var _purple = Color("#8E478C")
var _yellow = Color("#F4B41B")
var _red = Color("#E6482E")

@export_enum("none,blue,purple,yellow,red") var key_colour

func _ready() -> void:
	match key_colour:
		1:
			$Cube.get_surface_override_material(0).albedo_color = _blue
			$Torus.get_surface_override_material(0).albedo_color = _blue
		2:
			$Cube.get_surface_override_material(0).albedo_color = _purple
			$Torus.get_surface_override_material(0).albedo_color = _purple
		3:
			$Cube.get_surface_override_material(0).albedo_color = _yellow
			$Torus.get_surface_override_material(0).albedo_color = _yellow
		4:
			$Cube.get_surface_override_material(0).albedo_color = _red
			$Torus.get_surface_override_material(0).albedo_color = _red

func enable():
	$key/CollisionShape3D.disabled = false
