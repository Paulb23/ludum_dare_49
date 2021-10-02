extends Node3D

@export_enum("none,blue,purple,yellow,red") var colour

var _blue = Color("#28CCDF")
var _purple = Color("#8E478C")
var _yellow = Color("#F4B41B")
var _red = Color("#E6482E")

func _ready() -> void:
	var mat  = $Cube.get_surface_override_material(0).duplicate()
	$Cube.set_surface_override_material(0, mat)

	mat  = $Cylinder.get_surface_override_material(0).duplicate()
	$Cylinder.set_surface_override_material(0, mat)

	$Cube.get_surface_override_material(0).albedo_texture = null
	$Cylinder.get_surface_override_material(0).albedo_texture = null
	match colour:
		1:
			$Cube.get_surface_override_material(0).albedo_color = _blue
			$Cylinder.get_surface_override_material(0).albedo_color = _blue
		2:
			$Cube.get_surface_override_material(0).albedo_color = _purple
			$Cylinder.get_surface_override_material(0).albedo_color = _purple
		3:
			$Cube.get_surface_override_material(0).albedo_color = _yellow
			$Cylinder.get_surface_override_material(0).albedo_color = _yellow
		4:
			$Cube.get_surface_override_material(0).albedo_color = _red
			$Cylinder.get_surface_override_material(0).albedo_color = _red
