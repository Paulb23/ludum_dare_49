extends Node3D

@export_enum("none,blue,purple,yellow,red") var colour

var _grey = Color(0.35926750302315, 0.36328125, 0.36027094721794)
var _blue = Color("#28CCDF")
var _purple = Color("#8E478C")
var _yellow = Color("#F4B41B")
var _red = Color("#E6482E")

func _ready() -> void:
	set_up_colour()

func set_up_colour():
	if $Cylinder.get_surface_override_material(0) == null:
		$Cylinder.set_surface_override_material(0, StandardMaterial3D.new())

	$Cylinder.get_surface_override_material(0).albedo_color = _grey
	match colour:
		1:
			$Cylinder.get_surface_override_material(0).albedo_color = _blue
		2:
			$Cylinder.get_surface_override_material(0).albedo_color = _purple
		3:
			$Cylinder.get_surface_override_material(0).albedo_color = _yellow
		4:
			$Cylinder.get_surface_override_material(0).albedo_color = _red
