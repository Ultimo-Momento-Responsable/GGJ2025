extends RichTextLabel

var amplitude : float = 10.0
var frequency : float = 5.0
var time : float = 0

func _process(delta):
	time += delta
	position.y = amplitude * sin(time * frequency)
