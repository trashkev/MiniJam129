extends Node2D
@onready var animationPlayer = $AnimationPlayer
		
func nextScene():
	get_tree().change_scene_to_file("res://scenes/levels/Level_4.tscn")

func _on_area_2d_body_entered(body):
	if body is Player:
		animationPlayer.play("WIN")
	
