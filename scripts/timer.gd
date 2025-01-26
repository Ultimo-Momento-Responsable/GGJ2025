extends Label

var elapsed_time = 90

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.finished == false:
		elapsed_time -= delta
		if elapsed_time < 9:
			text = "0:0" + str(ceil(elapsed_time))
		elif elapsed_time < 59:
			text = "0:" + str(ceil(elapsed_time))
		elif elapsed_time < 69:
			text = "1:0" + str(ceil(elapsed_time) - 60)
		else:
			text = "1:" + str(ceil(elapsed_time) - 60)
	if (elapsed_time < 0) || Input.is_action_just_pressed("reset"):
		_reset_values()
		_change_scene()

func _reset_values():
	var player1 = get_tree().get_root().get_node("/root/Control/SubViewportContainer/SubViewport/ArenaBase/WorldEnvironment/Player1")
	var player2 = get_tree().get_root().get_node("/root/Control/SubViewportContainer/SubViewport/ArenaBase/WorldEnvironment/Player2")
	
	Global.deaths_player_1 = player1.deaths
	Global.deaths_player_2 = player2.deaths
	Global.finished = true
	player1.deaths = 0
	player2.deaths = 0
	player1.boosters = 0
	player2.boosters = 0
	elapsed_time = 90

func _change_scene():
	# Load in some scene from our project files:
	get_tree().change_scene_to_file("res://scenes/score.tscn")
