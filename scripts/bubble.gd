extends CharacterBody3D
class_name Bubble

@export var acceleration: float = 30
@export var max_speed: float = 30
@export var friction: float = 20
@export var player: String = "1"
var coolDown: float = 0.2

func _ready() -> void:
	# Set color according to which type of bubble I am
	var my_material = get_node("MeshInstance3D").get_mesh().get_material()
	if name == "Player1":
		my_material.set_shader_parameter("outline_color", Vector4( 0.192, 0.166, 0.69, 1.0 ))
	if name == "Player2":
		my_material.set_shader_parameter("outline_color", Vector4( 0.25, 1.0, 0.35, 1.0 ))
	if name == "bubble_booster":
		my_material.set_shader_parameter("outline_color", Vector4( 1.0, 1.0, 1.0, 1.0 ))

func _physics_process(delta: float) -> void:
	_custom_physics(delta)

func _custom_physics(delta: float) -> void:
	if coolDown > 0:
		coolDown -= delta

	var input_direction = Input.get_vector("move_left_player" + player, "move_right_player" + player, "move_down_player" + player, "move_up_player" + player)
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

	# Detectar colisiones
	if get_slide_collision_count() > 0:
		for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			var collision_normal = collision.get_normal()

			if collider and collider is Bubble:
				_handle_bubble_collision(collider as Bubble, collision_normal)
			elif collider and collider.is_in_group("hazards"):
				_pop_bubble()
			elif collider and collider.is_in_group("boosters"):
				collider.queue_free()
				scale += Vector3(0.3, 0.3, 0.3)
				if max_speed > 8:
					max_speed -= 2
			else:
				_bounce(collision_normal)

func _handle_bubble_collision(other_bubble: Bubble, collision_normal: Vector3) -> void:
	# Simular física de bolas de billar
	var relative_velocity = velocity - other_bubble.velocity
	var collision_speed = relative_velocity.dot(collision_normal)

	if collision_speed > 0:
		return  # Las burbujas ya están separándose, no procesar la colisión

	# Intercambiar velocidades según la normal de colisión
	velocity -= collision_normal * collision_speed
	other_bubble.velocity += collision_normal * collision_speed

func _pop_bubble() -> void:
	queue_free()

func _bounce(normal: Vector3) -> void:
	velocity = velocity.bounce(normal)
