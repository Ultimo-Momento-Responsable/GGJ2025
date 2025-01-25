extends Node3D

var player = "1"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	_process_player_input()
	
	
func _process_player_input():
	if Input.is_action_pressed("move_up_player" + player):
		pass
	elif Input.is_action_pressed("move_down_player1" + player):
		pass
		
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
