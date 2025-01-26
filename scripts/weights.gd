extends Node3D

# Carga la escena del objeto que quieres instanciar
@export var hazzard: PackedScene

func spawn_object():
	var new_object = hazzard.instantiate()
	add_child(new_object)
	new_object.global_transform.origin = Vector3(randf_range(-12, 12), 8.0, 0)
