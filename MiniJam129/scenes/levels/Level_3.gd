extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _enter_tree():
	if Checkpoint.last_position:
		$Player.global_position = Checkpoint.last_position
