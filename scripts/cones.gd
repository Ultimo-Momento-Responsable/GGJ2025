extends Node3D

@export var cone: PackedScene
var move_speed = 5.0 # Speed at which the cones move
var edge_distance = 20.0 # Distance from the edge to stop the cone
var x_edge_offset: float = 20
var y_edge_offset: float = 20
var x_edge: float = 16
var y_edge: float = 8
var posible_x_positions = [-14,-10,-6,-2,2,6,10,14]
var posible_y_positions = [-6,-2,2,6]
var positions_top_used = []
var positions_bottom_used = []
var positions_left_used = []
var positions_right_used = []
func spawn_object():
	var facing_position: Vector3
	var initial_position: Vector3
	var target_position: Vector3
	var random_x = randi_range(0, posible_x_positions.size()-1)
	var random_y = randi_range(0, posible_y_positions.size()-1)
	var tries = 0
	var already_instantiate = false
	
	var rotation_axis: Vector3
	match randi_range(0, 3):
		0: # bottom
			while (positions_bottom_used.has(posible_x_positions[random_x])):
				random_x = randi_range(0, posible_x_positions.size()-1)
				tries += 1
				if tries == 10:
					already_instantiate = true
					break
			positions_bottom_used.append(posible_x_positions[random_x])
			facing_position = Vector3(0, 0, 0)
			initial_position = Vector3(posible_x_positions[random_x], -y_edge_offset, 0)
			target_position = Vector3(posible_x_positions[random_x], -y_edge, 0)
			rotation_axis = Vector3(0, 1, 0)
		1: # right
			while (positions_right_used.has(posible_y_positions[random_y])):
				random_y = randi_range(0, posible_y_positions.size()-1)
				tries += 1
				if tries == 10:
					already_instantiate = true
					break
			positions_right_used.append(posible_y_positions[random_y])
			facing_position = Vector3(0, 0, 90)
			initial_position = Vector3(x_edge_offset, posible_y_positions[random_y], 0)
			target_position = Vector3(x_edge, posible_y_positions[random_y], 0)
			rotation_axis = Vector3(1, 0, 0)
		2: # top
			while (positions_top_used.has(posible_x_positions[random_x])):
				random_x = randi_range(0, posible_x_positions.size()-1)
				tries += 1
				if tries == 10:
					already_instantiate = true
					break
			positions_top_used.append(posible_x_positions[random_x])
			facing_position = Vector3(0, 0, 180)
			initial_position = Vector3(posible_x_positions[random_x], y_edge_offset, 0)
			target_position = Vector3(posible_x_positions[random_x], y_edge, 0)
			rotation_axis = Vector3(0, 1, 0)
		3: # left
			while (positions_left_used.has(posible_y_positions[random_y])):
				random_y = randi_range(0, posible_y_positions.size()-1)
				tries += 1
				if tries == 10:
					already_instantiate = true
					break
			positions_left_used.append(posible_y_positions[random_y])
			facing_position = Vector3(0, 0, 270)
			initial_position = Vector3(-x_edge_offset, posible_y_positions[random_y], 0)
			target_position = Vector3(-x_edge, posible_y_positions[random_y], 0)
			rotation_axis = Vector3(1, 0, 0)
	if !already_instantiate:
		var cone = cone.instantiate()
		add_child(cone)
		cone.rotation_axis = rotation_axis
		cone.get_child(0).rotation_degrees = facing_position
		cone.initial_rotation = facing_position.z
		cone.position = initial_position

		cone.is_moving = true
		cone.target_position = target_position
