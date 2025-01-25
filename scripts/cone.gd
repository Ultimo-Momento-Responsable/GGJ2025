extends RigidBody3D
var rotation_speed : float = 45.0 # Degrees per second
var target_position : Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#rotation_degrees.x += rotation_speed * delta
	rotate_object_local(Vector3(0, 1, 0), rotation_speed * delta * deg_to_rad(1))
	pass
