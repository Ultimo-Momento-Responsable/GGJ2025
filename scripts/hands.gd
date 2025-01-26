extends Node3D

@export var hand: PackedScene

func spawn_object() -> void:
	var hand_instance = hand.instantiate()
	hand_instance.start = randi_range(0, 3)
	add_child(hand_instance)
