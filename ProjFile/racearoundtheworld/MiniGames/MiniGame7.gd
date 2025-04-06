extends Node2D

@onready var opt1 = $Gassneeded/o1
@onready var opt2 = $Gassneeded/o2
@onready var opt3 = $Gassneeded/o3
@onready var timeout_timer: Timer = $TimeoutTimer 

var correct_option: int = -1
var game_over := false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# Hide all icons by default
	opt1.visible = false
	opt2.visible = false
	opt3.visible = false

	# Pick a random correct option
	correct_option = randi_range(1, 3)

	# Show the correct one
	match correct_option:
		1: opt1.visible = true
		2: opt2.visible = true
		3: opt3.visible = true

	print("✅ Correct option is:", correct_option)


	timeout_timer.start()

func _on_timeout_timer_timeout():
	if not game_over:
		print("⌛ Time's up!")
		game_over = true
		Gamemanager.mini_game_lost()

func _on_option_one_pressed() -> void:
	_check_answer(1)

func _on_option_two_pressed() -> void:
	_check_answer(2)

func _on_option_three_pressed() -> void:
	_check_answer(3)

func _check_answer(selected: int):
	if game_over:
		return

	game_over = true
	timeout_timer.stop()

	if selected == correct_option:
		print("🎯 Correct!")
		Gamemanager.mini_game_won()
	else:
		print("❌ Wrong!")
		Gamemanager.mini_game_lost()
