extends CharacterBody3D

signal key_collected

const _air_speed := 10
const _move_speed := 10
const _run_speed := 10

var _jump_force := 30
var _next_is_jump := -1
var _gravity := 5

@onready var _mouse_pivot := $head
var _min_look_angle := -50.0
var _max_look_angle := 75.0

var _mouse_sensitivity := 50
var _invert_y_axsis := false
var _mouse_delta := Vector2.ZERO
var _start_postion
var _start_rot

var _item
var _has_item = false
var _can_open_yellow = false

@onready var _ray_cast := $head/RayCast3D

var keys_collected = 0

func _ready() -> void:
	_start_postion = position
	_start_rot = rotation
	$head/camera.current = true

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

	if _has_item:
		if Input.is_action_just_pressed("interact"):
			_item.global_transform.origin = $head/hand.global_transform.origin
			_has_item = false
			_item.freeze = false
			return
		else:
			_item.global_transform.origin = $head/hand.global_transform.origin

	if not _has_item and _ray_cast.is_colliding():
		$Label.visible = true

		if Input.is_action_just_pressed("interact"):
			if String(_ray_cast.get_collider().get_name()).find("intractable") != -1:
				_item = _ray_cast.get_collider()
				_has_item = true
				_item.freeze = true
				return

			var obj = _ray_cast.get_collider().get_parent()
			if keys_collected == 0 && obj.get_name() == "blue_key_box":
				obj.open()
				get_tree().call_group("level_1_key", "enable")
			if keys_collected == 1 && _can_open_yellow && obj.get_name() == "yellow_key_box":
				obj.open()
				get_tree().call_group("level_2_key", "enable")

			if _ray_cast.get_collider().get_name() == "key":
				obj.queue_free()
				keys_collected += 1
				match keys_collected:
					1:
						$items/blue_key.visible = true
					2:
						$items/purple_key.visible = true
					3:
						$items/yellow_key.visible = true
					4:
						$items/red_key.visible = true
				key_collected.emit()

	else:
		$Label.visible = false

func respawn():
	position = _start_postion
	rotation = _start_rot
	_has_item = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if event.is_action("ui_cancel") and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED && event is InputEventMouseMotion:
		_mouse_delta = event.relative

func _on_pressure_plate_all_placed() -> void:
	if _has_item:
		_can_open_yellow = false
		return
	_can_open_yellow = true
