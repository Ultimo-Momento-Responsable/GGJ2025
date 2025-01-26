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

var positions_top = []
var positions_bottom = []
var positions_left = []
var positions_right = []

var range = [0, 1, 2, 3]

func _ready() -> void:
	for i in range(4):
		match i:
			0:
				for x in posible_x_positions:
					positions_bottom.append(Vector3(x, -y_edge_offset, 0))
			1:
				for y in posible_y_positions:
					positions_right.append(Vector3(x_edge_offset, y, 0))
			2:
				for x in posible_x_positions:
					positions_top.append(Vector3(x, y_edge_offset, 0))
			3:
				for y in posible_y_positions:
					positions_left.append(Vector3(-x_edge_offset, y, 0))
				

func spawn_object():
	if range.size() == 0:
		return
	var facing_position: Vector3
	var initial_position: Vector3
	var target_position: Vector3
	var tries = 0
	var already_instantiate = false
	
	var rotation_axis: Vector3
	match range.pick_random():
		0: # bottom
			var i = randi_range(0, positions_bottom.size() - 1)
			facing_position = Vector3(0, 0, 0)
			initial_position = positions_bottom[i]
			target_position = Vector3(positions_bottom[i].x, -y_edge, 0)
			rotation_axis = Vector3(0, 1, 0)
			positions_bottom.remove_at(i)
			if positions_bottom.size() == 0:
				range.erase(0)
		1: # right
			var i = randi_range(0, positions_right.size() - 1)
			facing_position = Vector3(0, 0, 90)
			initial_position = positions_right[i]
			target_position = Vector3(x_edge, positions_right[i].y, 0)
			rotation_axis = Vector3(1, 0, 0)
			positions_right.remove_at(i)
			if positions_right.size() == 0:
				range.erase(1)
		2: # top
			var i = randi_range(0, positions_top.size() - 1)
			facing_position = Vector3(0, 0, 180)
			initial_position = positions_top[i]
			target_position = Vector3(positions_top[i].x, y_edge, 0)
			rotation_axis = Vector3(0, 1, 0)
			positions_top.remove_at(i)
			if positions_top.size() == 0:
				range.erase(2)
		3: # left
			var i = randi_range(0, positions_left.size() - 1)
			facing_position = Vector3(0, 0, 270)
			initial_position = positions_left[i]
			target_position = Vector3(-x_edge, positions_left[i].y, 0)
			rotation_axis = Vector3(1, 0, 0)
			positions_left.remove_at(i)
			if positions_left.size() == 0:
				range.erase(3)
	var cone = cone.instantiate()
	add_child(cone)
	cone.is_moving = true
	cone.position = initial_position
	cone.target_position = target_position
	cone.rotation_axis = rotation_axis
	cone.get_child(0).rotation_degrees = facing_position
	cone.initial_rotation = facing_position.z

	
