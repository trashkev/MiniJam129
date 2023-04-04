extends CharacterBody2D
class_name Player

@onready var coyote_timer = $CoyoteTimer
@onready var blink_timer = $BlinkTimer
@onready var die_timer = $DieTimer
@onready var sprite2d = $Sprite2D
@onready var animationPlayer = $AnimationPlayer
@onready var camera = $Camera2D
@onready var jumpSFX = $Jump
@onready var landSFX = $Land
@onready var dieSFX = $Die

@onready var trail = $Trail

@export var slimeParticleScene: PackedScene

const JUMP_VELOCITY = -550.0
const ACCELERATION = 400.0
const DECELERATION = 500.0
const AIR_DECELERATION = 0
const MAX_FALL_SPEED = 700
const MAX_SPEED = 190.0
const SPRINT_ACCELERATION = 700
const SPRINT_MAX_SPEED = 250.0

const gravity = 980


var currentSquash = 1.0
var currentSquashVelocity = 0.0
var squashTarget = 1.0
var squashSpringy = 100
var squashDamping = 2
var framesSinceStart = 0

var was_on_floor = true
var was_on_ceiling = false

var playerAlive = true
var has_jump = false

func die():
	
	if !playerAlive: return
	velocity.x = 0
	velocity.y = 0
	playerAlive = false
	animationPlayer.play("Die")
	die_timer.start()
	camera.add_trauma(0.4)
	dieSFX.pitch_scale = randf_range(0.8,1)
	dieSFX.play()
	
	var slimeParticleInstance = slimeParticleScene.instantiate()
	get_parent().add_child(slimeParticleInstance)
	slimeParticleInstance.transform = transform
		
	pass

func accelerate(direction,delta):
	if Input.is_action_pressed("speed_up") and is_on_floor():
		velocity.x += direction * SPRINT_ACCELERATION * delta
	else:
		velocity.x += direction * ACCELERATION * delta

func decelerate(direction,delta):
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, AIR_DECELERATION * delta)
func updateMovement(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = clamp(velocity.y, -INF, MAX_FALL_SPEED)
	else:
		coyote_timer.stop()

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or (!coyote_timer.is_stopped() and has_jump)):
		has_jump = false
		velocity.y = JUMP_VELOCITY
		jumpSFX.pitch_scale = randf_range(0.7,1.4)
		jumpSFX.play()
		var slimeParticleInstance = slimeParticleScene.instantiate()
		get_parent().add_child(slimeParticleInstance)
		slimeParticleInstance.transform = transform
	
	if (Input.is_action_just_released("jump") and !is_on_floor() and velocity.y < 0):
		velocity.y += 0.5 * abs(velocity.y)	


	var speedCap
	if is_on_floor() and Input.is_action_pressed("speed_up"):
		speedCap = SPRINT_MAX_SPEED
	else:
		speedCap = MAX_SPEED
		
	var direction = Input.get_axis("move_left", "move_right")	
	if direction:
		if abs(velocity.x) < speedCap:
			accelerate(direction,delta)
		elif sign(velocity.x) != direction:
			accelerate(direction,delta)
		else:
			decelerate(direction,delta)
	else:
		decelerate(direction,delta)
	
	was_on_floor = is_on_floor()
	was_on_ceiling = is_on_ceiling()
	move_and_slide()
	
	if(is_on_floor()): has_jump = true
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		#print("collided with: ", collision.get_collider().collision_layer)
		if collision.get_collider() is TileMap:
			var rid = collision.get_collider_rid()
			var layer = PhysicsServer2D.body_get_collision_layer(rid)
			#print("layer " + str(layer))
			if layer == 16:
				die()
			return	
		if collision.get_collider().collision_layer == 2:
			collision.get_collider().poison()
		
	#BLINK CHECK (if you JUST landed or hit ceiling)
	if((!was_on_floor && is_on_floor()) or !was_on_ceiling && is_on_ceiling()):
		blink_timer.start()
		landSFX.pitch_scale = randf_range(0.8,1)
		landSFX.play()
		
		var slimeParticleInstance = slimeParticleScene.instantiate()
		get_parent().add_child(slimeParticleInstance)
		slimeParticleInstance.transform = transform
		
	#COYOTE CHECK (if you JUST left the floor)
	if was_on_floor && !is_on_floor():
		coyote_timer.start()
	
func updateSpriteSquish(vel,delta):
	if(!playerAlive):return
	framesSinceStart += 1
	var stretchAmount = 0.1
	if !is_on_floor(): stretchAmount = 0.04
	sprite2d.scale.x = 0.5 + vel.x/ MAX_SPEED * stretchAmount * (sin(framesSinceStart*0.2)/2)
	
	squashTarget = (abs(vel.y)/2000) + 1.0
	var dampingFactor = max(0,1 - squashDamping * delta)
	var acceleration = (squashTarget - currentSquash) * squashSpringy * delta
	currentSquashVelocity = currentSquashVelocity * dampingFactor + acceleration
	currentSquash += currentSquashVelocity * delta
	
	sprite2d.scale.y = currentSquash * 0.5
	if(!blink_timer.is_stopped()):
		sprite2d.frame = 1
	else:
		sprite2d.frame = 0
		
func _physics_process(delta):
	
	
	if !playerAlive and die_timer.is_stopped():
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("Restart"):
		die()
	
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()
	
		
	if(playerAlive):
		updateMovement(delta)
		trail.global_position = Vector2.ZERO
		trail.add_point(global_position + (Vector2.UP * 10))
		if trail.get_point_count() > 500:
			trail.remove_point(0)
		
	updateSpriteSquish(velocity,delta)

