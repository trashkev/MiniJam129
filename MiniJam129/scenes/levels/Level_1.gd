extends Node


func _ready():
	if PlayerDied.player_died != true:
		MusicController.play_music()
	else:
		pass


func _on_player_has_died():
	PlayerDied.player_died = true
	
	
func _enter_tree():
	if Checkpoint.last_position:
		$Player.global_position = Checkpoint.last_position
