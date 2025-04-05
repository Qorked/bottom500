extends Node
@onready var player = $Player2dBackForth
@onready var camera = $Camera2D
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	await get_tree().create_timer(10.0).timeout  # Simulate 2 sec gameplay
	var win = false  # or false, from your actual gameplay
	if win:
		Gamemanager.mini_game_won()
	else:
		Gamemanager.mini_game_lost()
	queue_free()
func _process(delta):
	if player and camera:
		var camera_bottom = camera.global_position.y + get_viewport().get_visible_rect().size.y / 2
		if player.global_position.y > camera_bottom:
			print("☠️ Player fell out of view")
			Gamemanager.mini_game_lost()
