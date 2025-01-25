extends Node3D  # Cambia a MeshInstance si estás trabajando directamente con una malla

# Velocidad de rotación en grados por segundo
@export var rotation_speed = 5.0

func _process(delta):
	# Convertir velocidad de rotación a radianes por segundo
	var rotation_radians = rotation_speed * delta
	# Rotar en el eje Y
	rotate_y(rotation_radians)
