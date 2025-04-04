extends Node

const TOTAL_GAMES := 20
const MAX_REPEATS := 2
const MINI_GAME_COUNT := 10
const SPEED_INCREMENT := 0.05

var mini_game_scenes := []
var played_games := {}
var current_score := 0
var current_speed := 1.0
var games_played := 0

#var transition_scene := preload("res://Transition.tscn")
var win_scene := preload("res://ui/winscreen.tscn")
var loss_scene := preload("res://ui/lossscreen.tscn")
var main_menu_scene := preload("res://ui/mainmenu.tscn")

func _ready():
	for i in range(1, MINI_GAME_COUNT + 1):
		mini_game_scenes.append(preload("res://MiniGames/MiniGame%d.tscn" % i))
	reset_game()

func reset_game():
	played_games.clear()
	current_score = 0
	current_speed = 1.0
	games_played = 0
	Engine.time_scale = 1.0

func start_game():
	reset_game()
	_load_next_minigame()

func _load_next_minigame():
	if games_played >= TOTAL_GAMES:
		_end_game(True)
		return

	var valid_choices = []
	for i in range(mini_game_scenes.size()):
		var times_played = played_games.get(i, 0)
		if times_played < MAX_REPEATS:
			valid_choices.append(i)

	if valid_choices.is_empty():
		_end_game(True)
		return

	var choice = valid_choices[randi() % valid_choices.size()]
	played_games[choice] = played_games.get(choice, 0) + 1
	games_played += 1

	var scene = mini_game_scenes[choice].instantiate()
	get_tree().root.call_deferred("add_child", scene)
	Engine.time_scale = current_speed

func mini_game_won():
	current_score += 1
	current_speed += SPEED_INCREMENT
	Engine.time_scale = 1.0
	_change_scene(transition_scene)

func mini_game_lost():
	_end_game(False)

func _end_game(victory: bool):
	Engine.time_scale = 1.0
	if victory:
		_change_scene(win_scene)
	else:
		_change_scene(loss_scene)

func go_to_main_menu():
	_change_scene(main_menu_scene)

func _change_scene(scene: PackedScene):
	get_tree().root.call_deferred("clear_children")
	get_tree().root.call_deferred("add_child", scene.instantiate())
