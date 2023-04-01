extends CharacterBody2D


const JUMP_VELOCITY = -350.0
const ACCELERATION = 500.0
const DECELERATION = 500.0
const MAX_SPEED = 130.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 980


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x += direction * ACCELERATION * delta
		velocity.x = clamp(velocity.x,-MAX_SPEED,MAX_SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)

	move_and_slide()
