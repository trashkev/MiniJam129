extends GPUParticles2D
@onready var timer = $Timer
@onready var SFX = $AudioStreamPlayer2D
func _ready():
	if SFX:
		SFX.pitch_scale = randf_range(.7,1.1)
		SFX.play()
	emitting = true
	pass
func _process(delta):
	if timer.is_stopped():
		queue_free()
	pass
