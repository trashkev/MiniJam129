extends Area2D

func _on_body_entered(body):
	if body is Player:
		var currentLevelIndex = get_tree().current_scene.name.to_int()
		print("leaving Level_" + str(currentLevelIndex))
		print("loading Level_" + str(currentLevelIndex+1))
		get_tree().change_scene_to_file("res://scenes/levels/Level_" + str(currentLevelIndex+1) + ".tscn")
				
