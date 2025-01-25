extends CharacterBody3D

@export var acceleration: float = 30
@export var max_speed: float = 30
@export var friction: float = 20
@export var player: String = "1"

func _physics_process(delta: float) -> void:
	_custom_physics(delta)

func _custom_physics(delta: float) -> void:
	var input_direction = Vector2.ZERO

	input_direction = Input.get_vector("move_left_player" + player, "move_right_player" + player, "move_down_player" + player, "move_up_player" + player)
	input_direction = input_direction.normalized()

	if input_direction != Vector2.ZERO:
		velocity += Vector3(input_direction.x, input_direction.y, 0) * acceleration * delta
		if velocity.length() > max_speed:
			velocity = velocity.normalized() * max_speed
	else:
		if velocity.length() > 0:
			velocity -= velocity.normalized() * friction * delta
		else:
			velocity = Vector3.ZERO

	move_and_slide()
