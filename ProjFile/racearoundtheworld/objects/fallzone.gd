extends Area2D
func _process(delta):
	if global_position.y > fall_limit:
		print("💀 Fell too far!")
		Gamemanager.mini_game_lost()
