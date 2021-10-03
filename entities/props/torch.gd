extends Node3D

var noise
@onready var rand = RandomNumberGenerator.new()
var value = 0.0
const MAX_VALUE = 100000

func _ready() -> void:
	value = rand.randi() % MAX_VALUE
	randomize()
	noise = OpenSimplexNoise.new()
	noise.period = 16

func _physics_process(delta: float) -> void:
	value += 0.5
	if (value > MAX_VALUE):
		value = 0.0
	var alpha = ((noise.get_noise_1d(value) + 1) / 5.0) + 0.5
	$OmniLight3D.light_energy = alpha
