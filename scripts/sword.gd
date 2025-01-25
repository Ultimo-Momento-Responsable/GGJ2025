extends RigidBody3D

@export var base_speed: float = 10.0
#@export var angular_speed_y: float = 10.0
@export var angular_speed_z: float = 5.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	linear_velocity = base_speed * Vector3.UP
	angular_velocity = angular_speed_z * Vector3.BACK

func _on_body_entered(body:Node):
	print(body, " entered")
