extends Area2D

func ready():
	pass


func _on_body_entered(body):
	Checkpoint.last_position = global_position
