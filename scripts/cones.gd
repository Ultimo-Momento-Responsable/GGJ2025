extends Node3D

@export var cone: PackedScene
@export var spawn_interval = 5  # Tiempo entre instancias en segundos
var move_speed = 5.0 # Speed at which the cones move
var edge_distance = 20.0 # Distance from the edge to stop the cone
var x_edge_offset: float = 20
var y_edge_offset: float = 20
var x_edge: float = 16
var y_edge: float = 8
var spawn_timer = 0.0

func _process(delta):
	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_timer = 0.0
		spawn_object()


func spawn_object():
	var facing_position: Vector3
	var initial_position: Vector3
	var target_position: Vector3
	var random_x = randf_range(-x_edge+2, x_edge-2)
	var random_y = randf_range(-y_edge+2, y_edge-2)
	var rotation_axis: Vector3
	match randi_range(0, 3):
		0: # bottom
			facing_position = Vector3(0, 0, 0)
			initial_position = Vector3(random_x, -y_edge_offset, 0)
			target_position = Vector3(random_x, -y_edge, 0)
			rotation_axis = Vector3(0, 1, 0)
		1: # right
			facing_position = Vector3(0, 0, 90)
			initial_position = Vector3(x_edge_offset, random_y, 0)
			target_position = Vector3(x_edge, random_y, 0)
			rotation_axis = Vector3(1, 0, 0)
		2: # top
			facing_position = Vector3(0, 0, 180)
			initial_position = Vector3(random_x, y_edge_offset, 0)
			target_position = Vector3(random_x, y_edge, 0)
			rotation_axis = Vector3(0, 1, 0)
		3: # left
			facing_position = Vector3(0, 0, 270)
			initial_position = Vector3(-x_edge_offset, random_y, 0)
			target_position = Vector3(-x_edge, random_y, 0)
			rotation_axis = Vector3(1, 0, 0)
	var cone = cone.instantiate()
	add_child(cone)
	cone.rotation_axis = rotation_axis
	cone.get_child(0).rotation_degrees = facing_position
	cone.initial_rotation = facing_position.z
	cone.position = initial_position

	cone.is_moving = true
	cone.target_position = target_position
