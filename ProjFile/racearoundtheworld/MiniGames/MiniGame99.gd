extends Node

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	await get_tree().create_timer(10.0).timeout  # Simulate 2 sec gameplay
	var win = false  # or false, from your actual gameplay
	if win:
		Gamemanager.mini_game_won()
	else:
		Gamemanager.mini_game_lost()
	queue_free()
	
