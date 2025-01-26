extends RigidBody3D

var thudSound = preload("res://Assets/sound/weightThud.ogg")
var spawnSound = preload("res://Assets/sound/weightSpawn.ogg")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_contact_monitor(true)
	set_max_contacts_reported(5)
	$CollisionShape3D.disabled = true
	scale = Vector3(0.0, 0.0, 0.0)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector3(1.0, 1.0 ,1.0), 0.5)
	$AudioStreamPlayer2D.stream = spawnSound
	$AudioStreamPlayer2D.play()
	await tween.finished
	$CollisionShape3D.disabled = false
	apply_impulse(Vector3(0, -600, 0))
	# linear_velocity = base_speed * Vector3.DOWN

func _process(delta):
	pass

func _on_body_entered(body):
	if body is StaticBody3D:
		$AudioStreamPlayer2D.stream = thudSound
		$AudioStreamPlayer2D.play()
		$GPUParticles3D2.restart()
		$CollisionShape3D.set_deferred("disabled", true)
		var tween = create_tween()
		tween.tween_property(self, "position", position + Vector3(0.2, 0.2, 0.2), 0.5).set_trans(Tween.TRANS_SPRING)
		await tween.finished
		queue_free()
