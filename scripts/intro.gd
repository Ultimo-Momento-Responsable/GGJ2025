extends Control
@export var scene_to_change: PackedScene

func _process(delta) -> void:
	if Input.is_anything_pressed():
		get_tree().change_scene_to_packed(scene_to_change)
