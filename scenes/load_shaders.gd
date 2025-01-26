extends Control
@export var scene_to_change: PackedScene
var countdown: float = 3.0  # Time in seconds before scene change
var is_counting: bool = false  # Flag to track if countdown has started

func _process(delta) -> void:
	is_counting = true  # Start the countdown when input is pressed
	countdown -= delta
	if countdown <= 0:
		get_tree().change_scene_to_packed(scene_to_change)
