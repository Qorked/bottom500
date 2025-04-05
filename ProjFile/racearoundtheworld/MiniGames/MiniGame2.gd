extends Node

@export var time_limit: float = 20.0
var is_game_over: bool = false

@onready var fail_timer: Timer = $FailTimer

func _ready():
	# Start the countdown timer for failure
	fail_timer.wait_time = time_limit
	fail_timer.start()

func _on_fail_timer_timeout():
	if is_game_over:
		return
	is_game_over = true
	Gamemanager.mini_game_lost()
	queue_free()

func on_key_collected():
	if is_game_over:
		return
	is_game_over = true
	fail_timer.stop()
	Gamemanager.mini_game_won()
	queue_free()
