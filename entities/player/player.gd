extends CharacterBody3D

const _air_speed := 10
const _move_speed := 20
const _run_speed := 30

var _jump_force := 30
var _next_is_jump := -1
var _gravity := 5

@onready var _mouse_pivot := $head
var _min_look_angle := -40.0
var _max_look_angle := 75.0

var _mouse_sensitivity := 50
var _invert_y_axsis := false
var _mouse_delta := Vector2.ZERO

func _physics_process(delta: float) -> void:

	# mouse
	var rot = Vector3(_mouse_delta.y, _mouse_delta.x, 0) * _mouse_sensitivity * delta
	if _invert_y_axsis:
		_mouse_pivot.rotation.x += deg2rad(rot.x)
	else:
		_mouse_pivot.rotation.x -= deg2rad(rot.x)
	_mouse_pivot.rotation.x = deg2rad(clamp(rad2deg(_mouse_pivot.rotation.x), _min_look_angle, _max_look_angle))

	rotate_y(deg2rad(-rot.y))
	_mouse_delta = Vector2.ZERO

	# input
	var direction = Vector3(Input.get_action_strength("right") - Input.get_action_strength("left"), 0, Input.get_action_strength("backwards") - Input.get_action_strength("forward")).normalized()
	direction = (global_transform.basis.z * direction.z + global_transform.basis.x * direction.x)
	var move_speed = _move_speed if (not Input.is_action_pressed("sprint") or Input.get_action_strength("backwards") != 0) else _run_speed
	motion_velocity = direction * move_speed

	# jump
	if Input.is_action_pressed("jump") and is_on_floor():
		motion_velocity.y = _jump_force
		_next_is_jump += 1
	elif _next_is_jump != -1:
		motion_velocity.y += _jump_force
		_next_is_jump += 1
		if _next_is_jump > 3:
			_next_is_jump = -1

	# gravity
	if _next_is_jump == -1:
		if !is_on_floor():
			motion_velocity.y -= _gravity
		else:
			motion_velocity.y = -0.1

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if event.is_action("ui_cancel") and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if event is InputEventMouseMotion:
		_mouse_delta = event.relative

