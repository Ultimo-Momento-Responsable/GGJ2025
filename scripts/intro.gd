extends Control
@export var scene_to_change: PackedScene

func _process(delta) -> void:
	if _is_anything_just_pressed():
		get_tree().change_scene_to_packed(scene_to_change)

func _is_anything_just_pressed() -> bool:
	for event in InputMap.get_actions():
		if Input.is_action_just_pressed(event):
			return true
	return false
