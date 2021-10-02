extends RigidDynamicBody3D

@export_enum("none,cube,tri,ball,cyl,rect") var shape

var _start_transform

func _ready() -> void:
	var mesh
	var collision
	match shape:
		1: # cube
			mesh = BoxMesh.new()
			mesh.size = Vector3(1, 1, 1)

			collision = BoxShape3D.new()
			collision.size = Vector3(1, 1, 1)
		2: # tri
			mesh = PrismMesh.new()
			mesh.size = Vector3(1, 1, 1)

			collision = BoxShape3D.new()
			collision.size = Vector3(1, 1, 1)
		3: # ball
			mesh = SphereMesh.new()
			mesh.radius = 0.5
			mesh.height = 1

			collision = SphereShape3D.new()
			collision.radius = 0.5
		4: # cyl
			mesh = CylinderMesh.new()
			mesh.top_radius = 0.5
			mesh.bottom_radius = 0.5
			mesh.height = 1

			collision = CylinderShape3D.new()
			collision.radius = 0.5
			collision.height = 1
		5: # rect
			mesh = BoxMesh.new()
			mesh.size = Vector3(0.5, 0.5, 1)

			collision = BoxShape3D.new()
			collision.size = Vector3(0.5, 0.5, 1)

	$MeshInstance3D.mesh = mesh
	$CollisionShape3D.shape = collision

	_start_transform = global_transform

func reset_puzzle():
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	global_transform = _start_transform
