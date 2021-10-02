extends MeshInstance3D

signal all_placed
var max_bodies = 6

func _physics_process(delta: float) -> void:
	var bodies = $Area3D.get_overlapping_bodies()
	var count = 0
	for b in bodies:
		if b.get_name() == "player":
			continue
		count += 1
	if count == max_bodies:
		all_placed.emit()

