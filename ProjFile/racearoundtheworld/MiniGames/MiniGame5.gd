extends Node

@onready var game_timer: Timer = $timer

var win := false  # Or set based on your game logic
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(_delta):
	if Input.is_action_just_pressed("space"):
		if game_timer.time_left > 0:
			game_timer.paused = true
			print("⏸️ Timer paused at: ", game_timer.time_left)
			# You can set `win = true` here or based on some other logic

func _on_timer_timeout() -> void:
	if win:
		Gamemanager.mini_game_won()
	else:
		Gamemanager.mini_game_lost()
	queue_free()
