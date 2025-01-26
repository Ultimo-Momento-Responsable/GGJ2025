extends RigidBody3D

@export var speed = 20
@export var remaining_time = 4
var start_direction = Vector3.ZERO

var bounceSound = preload("res://Assets/sound/brickBounce.ogg")
var spawnSound = preload("res://Assets/sound/brickSpawn.ogg")

func _ready() -> void:
	set_contact_monitor(true)
	set_max_contacts_reported(5)
	$CollisionShape3D.disabled = true
	scale = Vector3(0.0, 0.0, 0.0)
	$AudioStreamPlayer2D.stream = spawnSound
	$AudioStreamPlayer2D.play()
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
	
func _on_body_entered(body):
	if body is StaticBody3D:
		$AudioStreamPlayer2D.stream = bounceSound
		$AudioStreamPlayer2D.play()
	
