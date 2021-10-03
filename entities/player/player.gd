extends CharacterBody3D

signal key_collected
signal locks_open
signal beakers_passed

const _air_speed := 10
const _move_speed := 10
const _run_speed := 10

var _jump_force := 30
var _next_is_jump := -1
var _gravity := 5

@onready var _mouse_pivot := $head
@onready var _beaker := $head/hand/beaker
var _min_look_angle := -50.0
var _max_look_angle := 75.0

var _mouse_sensitivity := 50
var _invert_y_axsis := false
var _mouse_delta := Vector2.ZERO
var _start_postion
var _start_rot
var _next_walk_sound = 1
var _player_walk_sound = false

var _can_pick_up_beakers = true
var _beaker_order = []
var _has_beaker = false

var _in_pause = false

var _item
var _has_item = false
var _can_open_yellow = false
var _can_open_red = false

@onready var _ray_cast := $head/RayCast3D

var _locks_unlocked = []
var keys_collected = 0

func _ready() -> void:
	_start_postion = position
	_start_rot = rotation
	$head/camera.current = true
	_load_settings()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _load_settings():
	_invert_y_axsis = GlobalSettings.get_setting("controls/invert_y")
	_mouse_sensitivity = GlobalSettings.get_setting("controls/mouse_sensitvity")

func _physics_process(delta: float) -> void:
	if _in_pause:
		return

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

	if (direction.x != 0 || direction.z != 0) and _player_walk_sound:
		_player_walk_sound = false
		get_node("walk_" + str(_next_walk_sound)).play()
		_next_walk_sound += 1
		if (_next_walk_sound > 4):
			_next_walk_sound = 1

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

	var dropped = false
	if _has_beaker && Input.is_action_just_pressed("drop"):
		_beaker.visible = false
		_has_beaker = false
		dropped = true
		$beaker_drop.play()

	if not _has_item and _ray_cast.is_colliding():
		var is_beaker = false
		if String(_ray_cast.get_collider().get_parent().get_name()).find("beaker") != -1:
			if not _can_pick_up_beakers:
				return
			var obj = _ray_cast.get_collider().get_parent()

			if (_has_beaker == false and obj.colour != null):
				$pickup.visible = true
				$drop.visible = false
				if (Input.is_action_just_pressed("interact")):
					_beaker.colour = obj.colour
					_beaker.set_up_colour()
					_beaker.visible = true
					_has_beaker = true
					$beaker_pickup.play()
					$pickup.visible = false
					$drop.visible = true
				return

			if (obj.colour == null):
				if _has_beaker:
					$drop.visible = false
				$main.text = str(_beaker_order.size()) + "/4\nLeft click to fill.\nRight click to drain."
				$main.visible = true

				if _has_beaker and Input.is_action_just_pressed("interact"):
					_beaker_order.push_back(_beaker.colour)
					_has_beaker = false
					_beaker.visible = false
					$pour.play()
					if (_beaker_order.size() == 4):
						if (_beaker_order[0] != 1 || _beaker_order[1] != 2 || _beaker_order[2] != 3 || _beaker_order[3] != 4):
							respawn()
						else:
							_can_pick_up_beakers = false
							$main.visible = false
							_can_open_red = true
							beakers_passed.emit()

				if not dropped and not _has_beaker and Input.is_action_just_pressed("drop"):
					_beaker_order.clear()
			return
		else:
			$main.visible = false
			if keys_collected == 0 && _ray_cast.get_collider().get_parent().get_name() == "purple_key_box" or _ray_cast.get_collider().get_parent().get_name() == "red_key_box" && not _can_open_red:
				pass
			elif _has_beaker:
				$drop.visible = true
			else:
				$Label.visible = true

		if _has_beaker == false and Input.is_action_just_pressed("interact"):
			if String(_ray_cast.get_collider().get_name()).find("intractable") != -1:
				_item = _ray_cast.get_collider()
				_has_item = true
				_item.freeze = true
				return

			var obj = _ray_cast.get_collider().get_parent()
			if keys_collected == 0 && obj.get_name() == "blue_key_box":
				$box_open.play()
				obj.open()
				get_tree().call_group("level_1_key", "enable")
			elif keys_collected == 1 && obj.get_name() == "purple_key_box":
				$box_open.play()
				obj.open()
				get_tree().call_group("level_4_key", "enable")
			elif keys_collected == 2 && _can_open_yellow && obj.get_name() == "yellow_key_box":
				$box_open.play()
				obj.open()
				get_tree().call_group("level_2_key", "enable")
			elif keys_collected == 3 && _can_open_red && obj.get_name() == "red_key_box":
				$box_open.play()
				obj.open()
				get_tree().call_group("level_3_key", "enable")
			elif (String(obj.get_name()).find("key_box") != -1):
				$failed_unlock.play()

			if String(obj.get_name()).find("padlock") != -1:
				if _locks_unlocked.has(obj.colour):
					print("Cannot unlock")
				elif (keys_collected >= 1 && obj.colour == 1):
					$unlock.play()
					_locks_unlocked.push_back(obj.colour)
					obj.queue_free()
				elif (keys_collected >= 2 && obj.colour == 2):
					$unlock.play()
					_locks_unlocked.push_back(obj.colour)
					obj.queue_free()
				elif (keys_collected >= 3 && obj.colour == 3):
					$unlock.play()
					_locks_unlocked.push_back(obj.colour)
					obj.queue_free()
				elif (keys_collected >= 4 && obj.colour == 4):
					$unlock.play()
					_locks_unlocked.push_back(obj.colour)
					obj.queue_free()
				else:
					$failed_unlock.play()

				if _locks_unlocked.size() == 4:
					locks_open.emit()

			if _ray_cast.get_collider().get_name() == "key":
				$key_pickup.play()
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
		$pickup.visible = false
		$main.visible = false
		if _has_beaker:
			$drop.visible = true
		else:
			$drop.visible = false

func respawn():
	position = _start_postion
	rotation = _start_rot
	_has_item = false
	_has_beaker = false
	_beaker.visible = false
	_beaker_order.clear()

func _input(event: InputEvent) -> void:
	if not _in_pause and event is InputEventMouseButton and Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED && event is InputEventMouseMotion:
		_mouse_delta = event.relative

func _on_pressure_plate_all_placed() -> void:
	if _has_item:
		_can_open_yellow = false
		return
	_can_open_yellow = true


func _on_pause_menu_resume() -> void:
	_load_settings()
	$pause_menu.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_in_pause = false

func _show_pause() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_in_pause = true
	$pause_menu.visible = true


func _on_Timer_timeout() -> void:
	_player_walk_sound = true
