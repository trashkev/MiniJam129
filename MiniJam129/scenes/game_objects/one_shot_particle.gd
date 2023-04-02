extends GPUParticles2D
@onready var timer = $Timer
func _ready():
	emitting = true
	pass
func _process(delta):
	if timer.is_stopped():
		queue_free()
	pass
