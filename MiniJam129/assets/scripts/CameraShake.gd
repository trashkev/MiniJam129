extends Camera2D

var decay = 0.8  # How quickly the shaking stops [0, 1].
var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
var max_roll = 0.1  # Maximum rotation in radians (use sparingly).
var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].
# Called when the node enters the scene tree for the first time.

@onready var noise = FastNoiseLite.new()
var noise_y = 0

func _ready():
	trauma = 0
	randomize()
	noise.seed = randi()
	noise.frequency = 2
	noise.fractal_octaves = 1
	pass # Replace with function body.

func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()
	pass

func shake():
	var amount = pow(trauma, trauma_power)
	noise_y += 1
	rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed*2/1000, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*3/1000, noise_y)

