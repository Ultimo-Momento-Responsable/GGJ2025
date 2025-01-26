extends RigidBody3D

@export var speed = 20
@export var remaining_time = 4
var start_direction = Vector3.ZERO

func _ready() -> void:
	$CollisionShape3D.disabled = true
	scale = Vector3(0.0, 0.0, 0.0)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector3(1.0, 1.0 ,1.0), 2.0)
	await tween.finished
	$CollisionShape3D.disabled = false
	start_direction = Vector3(randf_range(-1, 1), randf_range(-1, 1), 0).normalized()
	linear_velocity = start_direction * speed

func _process(delta: float) -> void:
	if remaining_time <= 0:
		$CollisionShape3D.disabled = true
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector3(0.1, 0.1 ,0.1), 0.2)
		await tween.finished
		queue_free()
		return
	remaining_time -= delta
