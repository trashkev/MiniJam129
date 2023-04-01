extends CharacterBody2D

@onready var coyote_timer = $CoyoteTimer

const JUMP_VELOCITY = -350.0
const ACCELERATION = 500.0
const DECELERATION = 500.0
const MAX_SPEED = 160.0
const MAX_FALL_SPEED = 400

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 980


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = clamp(velocity.y, -INF, MAX_FALL_SPEED)

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or !coyote_timer.is_stopped()):
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x += direction * ACCELERATION * delta
		velocity.x = clamp(velocity.x,-MAX_SPEED,MAX_SPEED)
	
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)
	
	var was_on_floor = is_on_floor()
	
	move_and_slide()
	
	if was_on_floor && !is_on_floor():
		coyote_timer.start()
	

