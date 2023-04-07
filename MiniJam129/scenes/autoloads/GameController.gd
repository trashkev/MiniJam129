extends Node

@onready var player = $Player
@onready var camera = $Camera2D

var current_scene = null
var checkpointPos = Vector2(0,0)
var levelInitialSetupComplete = false

func _ready():
	print("Game Controller Loaded")
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	
func _process(delta):
	pass
	
func setUpLevel():
	if(levelInitialSetupComplete): return
	print("Setting up " + current_scene.name)
	if(!camera.enabled):
		camera.enabled = true
	
	var enterDoor = current_scene.get_node("EnterDoor")
	if(enterDoor):
		player.enable()
		
		setCheckpoint(enterDoor.position)
	else:
		player.disable()
	player.position = checkpointPos
	camera.position = checkpointPos
	levelInitialSetupComplete = true 
	
func loadLevelbyPath(path):
	levelInitialSetupComplete = false
	print("loading " + path)
	call_deferred("_deferred_goto_scene",(path))	
	
func loadLevelbyIndex(i):
	levelInitialSetupComplete = false
	print("loading Level_" + str(i))
	call_deferred("_deferred_goto_scene",("res://scenes/levels/Level_" + str(i) + ".tscn"))
func loadNextLevel():
	levelInitialSetupComplete = false
	var currentLevelIndex = current_scene.name.to_int()
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
