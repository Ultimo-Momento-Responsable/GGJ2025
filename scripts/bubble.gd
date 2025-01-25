extends CharacterBody3D
class_name Bubble

@export var acceleration: float = 30
@export var max_speed: float = 30
@export var friction: float = 20
@export var player: String = "1"
@export var aoe_range: float = 2  # Rango extra desde los bordes
@export var aoe_duration: float = 0.2  # Duración del AOE en segundos
@export var extra_size: float = 0.3
var boosters: int = 0
var aoe_active: bool = false  # Para evitar activar múltiples AOEs al mismo tiempo

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
	
	if Input.is_action_pressed("power_player" + player):
		if boosters > 0:
			_throw_power()
	
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
				boosters += 1
				scale += Vector3(extra_size, extra_size, extra_size)
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

func _throw_power() -> void:
	if aoe_active:
		return  # No permitir múltiples AOEs al mismo tiempo
	boosters -= 1
	scale -= Vector3(extra_size, extra_size, extra_size) 
	aoe_active = true
	
	# Crear un Area3D para el AOE
	var aoe = Area3D.new()
	var shape = SphereShape3D.new()
	var radius = (scale.x * 0.5) + aoe_range  # Tamaño de la burbuja más el rango extra
	shape.radius = radius

	var collision_shape = CollisionShape3D.new()
	collision_shape.shape = shape

	aoe.add_child(collision_shape)
	add_child(aoe)

	# Conectar señal para detectar otros personajes
	aoe.connect("body_entered", self._on_aoe_body_entered)

	# el AOE después de `aoe_duration`
	await get_tree().create_timer(aoe_duration).timeout
	aoe.queue_free()
	aoe_active = false

func _on_aoe_body_entered(body: Node) -> void:
	# Asegurarnos de que estamos afectando solo a las otras burbujas y no a sí mismo
	if body is Bubble and body != self:
		print("AOE hit bubble: ", body.name, " - ", self.name)
		apply_aoe_effect(body)  # Ahora pasamos el 'body', no 'self'

func apply_aoe_effect(target_bubble: Bubble) -> void:
	# Lógica para aplicar el efecto del AOE
	print("Applying AOE effect to: ", target_bubble.name, " from ", self.name)
	
	var direction = (target_bubble.global_transform.origin - global_transform.origin).normalized()  # Direccion opuesta a 'self'

	# La fuerza que se aplicará al personaje afectado
	var force = direction * 25  # Ajusta la magnitud de la fuerza a tu gusto

	# Si el objetivo es un personaje (Bubble), aplicamos la fuerza
	if target_bubble.is_in_group("bubbles"):
		target_bubble.velocity += force  # Aumentamos la velocidad en la dirección opuesta
