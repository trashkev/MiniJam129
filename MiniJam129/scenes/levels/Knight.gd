extends CharacterBody2D

var direction = Vector2.LEFT
var speed = 200
var fallSpeed = 400
func turnAround():
	scale.x *= -1
	if direction == Vector2.RIGHT: direction = Vector2.LEFT
	else: direction = Vector2.RIGHT
	pass
func _physics_process(delta):
	move_and_slide()
	if(is_on_floor()):
		velocity = direction * speed
	else:
		velocity = Vector2.DOWN * fallSpeed
		
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		#print("collided with: ", collision.get_collider().collision_layer)
		if collision.get_collider() is Player:
			collision.get_collider().call("die")
			speed=0
		
		if(is_on_wall()):
			turnAround()
		
	pass
	

