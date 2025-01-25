extends Node3D

# Carga la escena del objeto que quieres instanciar
@export var booster: PackedScene
@export var spawn_interval = 5  # Tiempo entre instancias en segundos

var spawn_timer = 0.0

func _process(delta):
	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_timer = 0.0
		spawn_object()

func spawn_object():
	var new_object = booster.instantiate()
	add_child(new_object)
	new_object.global_transform.origin = Vector3(randf_range(-18, 18), randf_range(-10, 10), 0)
	
