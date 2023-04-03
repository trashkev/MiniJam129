extends TextureButton

func _on_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/Level_0.tscn")
	get_tree().quit()
	pass # Replace with function body.
