extends Node

func ready():
	pass


func _enter_tree():
	if Checkpoint.last_position:
		$Player.global_position = Checkpoint.last_position
