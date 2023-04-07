extends Node

@onready var player = $Player
@onready var camera = $Camera2D

var current_scene = null
var checkpointPos = Vector2(0,0)


func _ready():
	print("Game Controller Loaded")
	
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	
	setUpLevel()
func _process(delta):
	pass
	
func setUpLevel():
	var enterDoor = current_scene.get_node("EnterDoor")
	if(enterDoor):
		player.enable()
		setCheckpoint(enterDoor.position)
	else:
		player.disable()
	player.position = checkpointPos
	camera.position = checkpointPos
func loadLevelbyPath(path):
	print("loading " + path)
	call_deferred("_deferred_goto_scene",(path))	
	setUpLevel()
	
func loadLevelbyIndex(i):
	print("loading Level_" + str(i))
	call_deferred("_deferred_goto_scene",("res://scenes/levels/Level_" + str(i) + ".tscn"))
	setUpLevel()
func loadNextLevel():
	var currentLevelIndex = current_scene.name.to_int()
	print("leaving Level_" + str(currentLevelIndex))
	print("loading Level_" + str(currentLevelIndex+1))
	loadLevelbyIndex(currentLevelIndex+1)
	
func _deferred_goto_scene(path):
	current_scene.free()
	
	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = current_scene
	
func reload_current_level():
	_deferred_goto_scene(current_scene.scene_file_path)
	player.position = checkpointPos
	
func setCheckpoint(pos):
	print("checkpoint set")
	checkpointPos = pos
	pass
func _on_player_has_died():
	print("on_has_died heard from game_controller")
	reload_current_level()
