extends Node

func _ready():
	# Replace with your game logic
	await get_tree().create_timer(10.0).timeout  # Simulate 2 sec gameplay
	var win = true  # or false, from your actual gameplay
	if win:
		Gamemanager.mini_game_won()
	else:
		Gamemanager.mini_game_lost()
	queue_free()
