extends CharacterBody3D
class_name Bubble

@export var acceleration: float = 30
@export var max_speed: float = 30
@export var friction: float = 20
@export var player: String = "1"
@export var aoe_range: float = 1.5  # Rango extra desde los bordes
@export var aoe_duration: float = 0.2  # Duración del AOE en segundos
@export var extra_size: float = 0.5
@export var power_force: float = 15
@export var initial_position: Vector3
@export var i_time = 1.5

var i_animation = 0
var deaths = 0
var initial_i_time = i_time
var initial_scale = scale
var initial_max_speed = max_speed
var boosters: int = 0
var aoe_active: bool = false  # Para evitar activar múltiples AOEs al mismo tiempo
var dying_state: bool = false

var deathSound = preload("res://Assets/sound/death.ogg")
var bumpSound = preload("res://Assets/sound/bump.ogg")
var boosterSound = preload("res://Assets/sound/getBooster.ogg")
var respawnSound = preload("res://Assets/sound/respawn.ogg")
var powerSound = preload("res://Assets/sound/bubblePower.ogg")
var wallSound = preload("res://Assets/sound/wallbump.ogg")

func playSound(sound):
	$AudioStreamPlayer2D.stream = sound
	$AudioStreamPlayer2D.play()

func _ready() -> void:
	# Set color according to which type of bubble I am
	var my_material = get_node("MeshInstance3D").get_mesh().get_material()
	if name == "Player1":
		my_material.set_shader_parameter("outline_color", Vector4( 0.192, 0.166, 0.69, 1.0 ))
	if name == "Player2":
		my_material.set_shader_parameter("outline_color", Vector4( 0.25, 1.0, 0.35, 1.0 ))

func _process(delta: float) -> void:
	if i_time > 0:
		if (i_animation % 4 == 0):
			visible = !visible
		i_animation += 1
	else: 
		visible = true

func _physics_process(delta: float) -> void:
	if i_time > 0:
		i_time -= delta
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

			if collider and collider.is_in_group("hazards"):
				if i_time <= 0:
					_pop_bubble()
			elif collider and collider is Bubble:
				_handle_bubble_collision(collider as Bubble, collision_normal)
			elif collider and collider.is_in_group("boundaries"):
				playSound(wallSound)
				_bounce(collision_normal)
			elif collider and collider.is_in_group("boosters"):
				playSound(boosterSound)
				collider.queue_free()
				boosters += 1
				scale += Vector3(extra_size, extra_size, extra_size)
				if max_speed > 8:
					max_speed -= 2

func _handle_bubble_collision(other_bubble: Bubble, collision_normal: Vector3) -> void:
	# Simular física de bolas de billar
	playSound(bumpSound)
	var relative_velocity = velocity - other_bubble.velocity
	var collision_speed = relative_velocity.dot(collision_normal)

	if collision_speed > 0:
		return  # Las burbujas ya están separándose, no procesar la colisión

	# Intercambiar velocidades según la normal de colisión
	velocity -= collision_normal * collision_speed
	other_bubble.velocity += collision_normal * collision_speed

func _pop_bubble() -> void:
	velocity = Vector3.ZERO
	if dying_state == false:
		playSound(deathSound)
		dying_state = true
		deaths += 1
		if get_tree().get_root().get_node("/root/Control/Scorebar/Player" + player + "Deaths"):
			get_tree().get_root().get_node("/root/Control/Scorebar/Player" + player + "Deaths").text = str(deaths)
		$MeshInstance3D.visible = false
		$GPUParticles3D.restart()
		$GPUParticles3D2.restart()
		await $GPUParticles3D.finished
		_reset_values()

func _reset_values():
	i_animation = 0
	i_time = initial_i_time
	position = initial_position
	scale = initial_scale
	boosters = 0
	max_speed = initial_max_speed
	dying_state = false
	playSound(respawnSound)
	$GPUParticles3D.restart()
	$MeshInstance3D.visible = true

func _bounce(normal: Vector3) -> void:
	velocity = velocity.bounce(normal)

func _throw_power() -> void:
	if aoe_active:
		return  # No permitir múltiples AOEs al mismo tiempo
	var previous_scale = scale
	aoe_active = true
	
	# Crear un Area3D para el AOE
	var aoe = Area3D.new()
	var shape = SphereShape3D.new()
	var radius = (previous_scale.x * 0.5) + aoe_range  # Tamaño de la burbuja más el rango extra
	shape.radius = radius

	var collision_shape = CollisionShape3D.new()
	collision_shape.shape = shape

	aoe.add_child(collision_shape)
	add_child(aoe)

	# Conectar señal para detectar otros personajes
	aoe.connect("body_entered", self._on_aoe_body_entered)
	
	# Crear y configurar el Tween
	var tween = create_tween()
	# Animar la escala para que se expanda
	playSound(powerSound)
	tween.tween_property(self, "scale", Vector3(scale.x + aoe_range * 2, scale.y + aoe_range * 2, scale.z + aoe_range * 2), aoe_duration)
	await tween.finished
	scale = initial_scale
	max_speed = initial_max_speed

	# el AOE después de aoe_duration
	await get_tree().create_timer(aoe_duration).timeout
	aoe.queue_free()
	aoe_active = false

func _on_aoe_body_entered(body: Node) -> void:
	# Asegurarnos de que estamos afectando solo a las otras burbujas y no a sí mismo
	if body is Bubble and body != self:
		apply_aoe_effect(body)  # Ahora pasamos el 'body', no 'self'

func apply_aoe_effect(target_bubble: Bubble) -> void:
	# Lógica para aplicar el efecto del AOE	
	var direction = (target_bubble.global_transform.origin - global_transform.origin).normalized()  # Direccion opuesta a 'self'

	# La fuerza que se aplicará al personaje afectado
	var force = direction * (power_force * boosters)   # Ajusta la magnitud de la fuerza a tu gusto
	boosters = 0
	# Si el objetivo es un personaje (Bubble), aplicamos la fuerza
	if target_bubble.is_in_group("bubbles"):
		target_bubble.velocity += force  # Aumentamos la velocidad en la dirección opuesta
