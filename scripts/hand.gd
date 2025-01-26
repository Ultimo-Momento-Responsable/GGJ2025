extends RigidBody3D

var start: int = 1
var state: int = 0
var wait_seconds: float = 0
var direction: Vector3
var time_to_dissapear = 4

var starting_positions := [
	Vector3(24.25, 0.25, 0),
	Vector3(24.25, -8.67, 0),
	Vector3(-24.25, 0.25, 0),
	Vector3(-24.25, -8.67, 0),
]

var target_position: Vector3
var move_speed: float = 20

var spawnSound = preload("res://Assets/sound/handSpawn.ogg")
var moveSound = preload("res://Assets/sound/handMove.ogg")

func playSound(sound):
	$AudioStreamPlayer2D.stream = sound
	$AudioStreamPlayer2D.play()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playSound(spawnSound)
	match start:
		0:
			position = starting_positions[start]
			direction = Vector3.LEFT
			target_position = starting_positions[start] + direction * 8
		1:
			position = starting_positions[start]
			direction = Vector3.LEFT
			target_position = starting_positions[start] + direction * 8
		2:
			position = starting_positions[start]
			direction = Vector3.RIGHT
			get_child(0).rotation_degrees = Vector3(0, 270, 0)
			target_position = starting_positions[start] + direction * 8
		3:
			position = starting_positions[start]
			direction = Vector3.RIGHT
			get_child(0).rotation_degrees = Vector3(0, 270, 0)
			target_position = starting_positions[start] + direction * 8

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_to_dissapear -= delta
	if time_to_dissapear < 0:
		queue_free()
		return
	match state:
		0:
			#spawn
			var has_reached_position = _move_towards_target_position(delta)
			if has_reached_position:
				state += 1
				wait_seconds = 0.5
		1:
			#wait a bit to enable physics
			wait_seconds -= delta
			if wait_seconds <= 0:
				state += 1
		2:
			#set new target position
			playSound(moveSound)
			var adjustment_constant = 37.5
			if start == 1 or start == 3:
				adjustment_constant = 37
			target_position = starting_positions[start] + direction * adjustment_constant
			state += 1
		3:
			#start moving towards new pos
			var has_reached_position = _move_towards_target_position(delta)
			if has_reached_position:
				state += 1
		4:
			#wait a bit to despawn
			var tween = create_tween()
			tween.tween_property(self, "scale", Vector3(0.1, 0.1 ,0.1), 0.2)
			await tween.finished
			queue_free()
	
func _move_towards_target_position(delta: float) -> bool:
	var direction = target_position - position
	var velocity = direction.normalized() * move_speed
	position += velocity * delta

	# Stop moving when close enough to the target
	if direction.length() < 0.1:
		position = target_position # Snap to position once it's close enough
		return true
	
	return false
