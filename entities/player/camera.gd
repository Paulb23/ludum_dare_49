extends Camera3D

@export var decay = 0.8  # How quickly the shaking stops [0, 1].
@export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).
var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].
var rand

func _ready():
	randomize()
	rand = RandomNumberGenerator.new()

func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)

func _physics_process(delta: float) -> void:
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()

func shake():
	var amount = pow(trauma, trauma_power)
	rotation.x = max_roll * amount * rand.randf_range(-1, 1)
	rotation.z = max_roll * amount * rand.randf_range(-1, 1)
