extends RigidBody3D

@export var speed = 20
@export var remaining_time = 4
var start_direction = Vector3.ZERO

func _ready() -> void:
	start_direction = Vector3(randf_range(-1, 1), randf_range(-1, 1), 0).normalized()
	linear_velocity = start_direction * speed


func _process(delta: float) -> void:
	if remaining_time <= 0:
		queue_free()
		return
		
	remaining_time -= delta
