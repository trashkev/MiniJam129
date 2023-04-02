extends StaticBody2D

@onready var destroy_timer = $DestroyTimer
@onready var slimeSprite = $Sprite2D/SlimeSprite
@onready var animationPlayer = $AnimationPlayer

@export var woodParticleScene: PackedScene
@export var slimeParticleScene: PackedScene


var poisoned = false

var frame = 1
var lastFrame = 1

func poison():
	if poisoned == false:
		print("IVE BEEN POISONED!")
		slimeSprite.visible = true
		poisoned = true
		destroy_timer.start()
		animationPlayer.play("Shake")
	
	
func destroy():
	
	var woodParticleInstance = woodParticleScene.instantiate()
	get_parent().add_child(woodParticleInstance)
	woodParticleInstance.transform = transform
	
	var slimeParticleInstance = slimeParticleScene.instantiate()
	get_parent().add_child(slimeParticleInstance)
	slimeParticleInstance.transform = transform
	
	queue_free()

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(poisoned):
		lastFrame = frame
		frame = floor((slimeSprite.hframes / destroy_timer.wait_time) * (destroy_timer.wait_time - destroy_timer.time_left))
		
		#if frame changed
		if(lastFrame<frame):
			animationPlayer.play("Shake")
			print(frame-1)
			slimeSprite.frame = frame - 1
		
	if(destroy_timer.is_stopped() and poisoned):
		destroy()
	pass
