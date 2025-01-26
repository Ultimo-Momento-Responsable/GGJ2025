extends Control
@export var scene_to_change: PackedScene
var countdown: float = 3.0  # Time in seconds before scene change
var is_counting: bool = false  # Flag to track if countdown has started

const gameScene = preload("res://scenes/arena_base.tscn")
var scenes_to_load = ["bubble", "bubbleBoost", "cone", "hand", "limits", "spike_ball", "sword", "weight"]
var masterAudio = AudioServer.get_bus_index("Master")

func preloadScenes(scenes):
	AudioServer.set_bus_mute(masterAudio, true)
	var resourcePath = "res://scenes/game_objects/%s.tscn"
	for scene in scenes:
		var resource = resourcePath % scene
		var loadedScene = load(resource).instantiate()
		add_child(loadedScene)
		if scene == "bubble":
			print("popping bubble")
			loadedScene._pop_bubble()
	var arena = load("res://scenes/arena_base.tscn").instantiate()
	add_child(arena)
	is_counting = true

func _ready() -> void:
	preloadScenes(scenes_to_load)
	
func _process(delta) -> void:
	if is_counting == true:
		countdown -= delta
		if countdown <= 0:
			AudioServer.set_bus_mute(masterAudio, false)
			get_tree().change_scene_to_packed(scene_to_change)
