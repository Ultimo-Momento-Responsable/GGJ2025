extends AudioStreamPlayer
@export var score_scene: PackedScene

func _ready():
	# Conectar la señal "finished" a una función
	connect("finished", self._on_audio_finished)
	play()

func _on_audio_finished():
	get_tree().change_scene_to_packed(score_scene)
