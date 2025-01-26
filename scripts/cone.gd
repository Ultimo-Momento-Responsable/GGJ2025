extends RigidBody3D
var target_position : Vector3
var rotation_speed : float = 45.0 # Degrees per second
var move_speed : float = 5.0 # Speed at which the cone moves
@export var is_moving: bool = true
var initial_rotation: float
var is_initial_position_set: bool = false
var rotation_axis: Vector3  = Vector3(0, 1, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_moving:
		position = Vector3(randf_range(-20, 20), 20, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#rotation_degrees.x += rotation_speed * delta
	rotate_object_local(rotation_axis, rotation_speed * delta * deg_to_rad(1))
	
	# If the cone is moving, handle its movement towards the target
	if is_moving:
		var direction = target_position - position
		var velocity = direction.normalized() * move_speed
		position += velocity * delta

		# Stop moving when close enough to the target
		if direction.length() < 0.1:
			position = target_position # Snap to position once it's close enough
			is_moving = false # Stop moving when we reach the edge
