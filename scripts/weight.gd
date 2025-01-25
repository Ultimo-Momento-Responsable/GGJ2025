extends RigidBody3D

# @export var base_speed: float = 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CollisionShape3D.disabled = true
	scale = Vector3(0.0, 0.0, 0.0)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector3(1.0, 1.0 ,1.0), 2.0)
	await tween.finished
	$CollisionShape3D.disabled = false
	apply_impulse(Vector3.DOWN)
	# linear_velocity = base_speed * Vector3.DOWN

func _process(delta):
	pass

func _on_body_entered(body:Node):
	print(body, " entered")
	
func destroy():
	queue_free()
