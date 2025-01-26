extends Node3D

var delay = 1

var quotes: Array = [
	"The harder the bubble, the sweeter the pop. – Les Brown", 
	"In the middle of the bubble’s rise lies the opportunity to burst it. – Albert Einstein",
	"It’s not the size of the bubble in the pop, but the size of the pop in the bubble. – Mark Twain",
	"The only competition you’ll ever face is the one inside your bubble. – Anonymous",
	"Victory is reserved for those who are willing to pop their bubbles. – Sun Tzu",
	"The bubble is not always to the strongest, but to the one who keeps on popping. – Anonymous",
	"You miss 100% of the pops you don’t try. – Wayne Gretzky",
	"The strongest bubble in the bunch is not the one that is protected from the air, but the one that rises and dares to pop. – Napoleon Hill",
	"A champion is afraid of bursting. Everyone else is afraid of popping. – Billie Jean King",
	"Success is no accident. It’s the bubble you blow, the perseverance to keep it floating, and the courage to make it pop. – Pelé"
]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Control/Scorebar/Player1Deaths.text = str(Global.deaths_player_1)
	$Control/Scorebar/Player2Deaths.text = str(Global.deaths_player_2)
	
	if Global.deaths_player_1 > Global.deaths_player_2:
		$Control/Result/Result.text = "Player 2 wins!"
	elif Global.deaths_player_2 > Global.deaths_player_1:
		$Control/Result/Result.text = "Player 1 wins!"
	else:
		$Control/Result/Result.text = "Draw!"
		
	var index = randi_range(0, quotes.size() - 1)
	$Control/Quote/Quote.text = quotes[index]
	

func _process(delta) -> void:
	delay -= delta
	if Input.is_anything_pressed() && delay < 0:
		print("reset")
		Global.finished = false
		get_tree().change_scene_to_file("res://scenes/viewport.tscn")
