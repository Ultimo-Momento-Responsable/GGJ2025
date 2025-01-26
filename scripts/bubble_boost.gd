extends CharacterBody3D

var acceleration = 5.0              # Aceleración fija
var max_speed = 10.0                # Velocidad máxima
var direction = Vector3.ZERO        # Dirección inicial aleatoria

func _ready():
	# Generar una dirección aleatoria al inicio
	scale = Vector3(0.0, 0.0, 0.0)
	direction = Vector3(randf_range(-1, 1), randf_range(-1, 1), 0).normalized()
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector3(1.0, 1.0 ,1.0), 0.2)

func _physics_process(delta):
	# Acelerar en la dirección inicial
	velocity += direction * acceleration * delta
	
	# Limitar la velocidad máxima
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed

	move_and_slide()
	
	if is_on_wall():
		for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			var normal = collision.get_normal()  # Obtén la normal de la colisión
			velocity = velocity.bounce(normal)
			direction = normal
			
			if collider and collider.is_in_group("hazards"):
				queue_free()

# Función auxiliar para generar un número aleatorio en un rango
func randf_range(min, max):
	return randf() * (max - min) + min
