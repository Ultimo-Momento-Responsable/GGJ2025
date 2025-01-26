extends Label

var elapsed_time = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	elapsed_time += delta
	
	if elapsed_time < 10:
		text = "0:0" + str(floor(elapsed_time))
	elif elapsed_time < 60:
		text = "0:" + str(floor(elapsed_time))
	elif elapsed_time < 70:
		text = "1:0" + str(floor(elapsed_time) - 60)
	else:
		text = "1:" + str(floor(elapsed_time) - 60)
