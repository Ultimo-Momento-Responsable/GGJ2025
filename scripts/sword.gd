extends RigidBody3D

@export var base_speed: float = 10.0
#@export var angular_speed_y: float = 10.0
@export var angular_speed_z: float = 10.0

var life_timer: float = 0.0
var life_time = 5.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CollisionShape3D.disabled = true
	scale = Vector3(0.0, 0.0, 0.0)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector3(1.0, 1.0 ,1.0), 2.0)
	await tween.finished
	$CollisionShape3D.disabled = false
	# linear_velocity = base_speed * Vector3.UP
	angular_velocity = angular_speed_z * Vector3.BACK

func _process(delta):
	life_timer += delta
	if life_timer >= life_time:
		destroy()

func _on_body_entered(body:Node):
	print(body, " entered")
	
func destroy():
	life_timer = 0.0
	$CollisionShape3D.disabled = true
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector3(0.1, 0.1 ,0.1), 0.2)
	await tween.finished
	queue_free()
