extends Node

@export var spawn_interval = 5  # Tiempo entre instancias en segundos

var spawn_timer = 0.0

func _process(delta):
	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		var hazzards = get_children()
		var index = randi_range(0, hazzards.size() - 1)
		var instance = hazzards[index]  # Instanciamos el script
		if instance.has_method("spawn_object"):
			instance.spawn_object()
		spawn_timer = 0.0
