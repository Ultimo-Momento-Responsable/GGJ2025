extends CharacterBody3D

@export var player: String = "1"
@export var acceleration: Vector3 = Vector3.ZERO # accel in m/s2
@export var mass: float = 5 # in kg
@export var applied_force: float = 1 # in Newtons
@export var friction_constant: float = 0.000005
var is_player_moving: bool = false
var previous_velocity: Vector3 = Vector3.ZERO
var delta_velocity: Vector3 = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	_process_player_input()
	_apply_custom_phisycs(delta)
	move_and_slide()
	
func _process_player_input() -> void:
	var input_direction = Input.get_vector("move_left_player" + player, "move_right_player"  + player, "move_down_player" + player, "move_up_player" + player).normalized()
	is_player_moving = input_direction != Vector2.ZERO
	acceleration += (Vector3(input_direction.x, input_direction.y, 0) * applied_force) / mass

func _apply_custom_phisycs(delta: float) -> void:
	_apply_friction()
	_apply_acceleration(delta)
	
func _apply_acceleration(delta: float) -> void:
	var adjusted_acceleration = acceleration * delta
	previous_velocity = velocity
	velocity += adjusted_acceleration
	delta_velocity = velocity - previous_velocity
	
func _apply_friction() -> void:
	if !is_equal_approx(velocity.length(), 0):
		var friction_direction = velocity.normalized() * -1
		acceleration += friction_constant * friction_direction
	else:
		acceleration = Vector3.ZERO

# Media panceta
# Media especial
# Media bongo bong
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
