extends Camera2D

func loadNextLevel():
	GameController.loadLevelbyIndex(1)
func _physics_process(delta):
	if Input.is_action_just_pressed("jump"):
		loadNextLevel()
	pass
