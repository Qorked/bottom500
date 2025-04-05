extends Node

const TOTAL_GAMES := 20
const MAX_REPEATS := 2
const MINI_GAME_COUNT := 1
const SPEED_INCREMENT := 0.05

var game_container: Node = null

var mini_game_scenes: Array[PackedScene] = []
var played_games: Dictionary = {}
var current_score: int = 0
var current_speed: float = 1.0
var games_played: int = 0

var transition_scene: PackedScene = preload("res://cutsceens/transition.tscn")
var win_scene: PackedScene = preload("res://ui/winscreen.tscn")
var loss_scene: PackedScene = preload("res://ui/lossscreen.tscn")
var main_menu_scene: PackedScene = preload("res://ui/mainmenu.tscn")

func set_game_container(container: Node) -> void:
	game_container = container

func _ready():
	randomize()
	for i in range(1, MINI_GAME_COUNT + 1):
		var path := "res://MiniGames/MiniGame{0}.tscn".format([i])
		mini_game_scenes.append(load(path))
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
		_end_game(true)
		return

	var valid_choices: Array[int] = []
	for i in mini_game_scenes.size():
		var times_played := int(played_games.get(i, 0))
		if times_played < MAX_REPEATS:
			valid_choices.append(i)

	if valid_choices.is_empty():
		_end_game(true)
		return

	var choice := valid_choices[randi() % valid_choices.size()]
	played_games[choice] = int(played_games.get(choice, 0)) + 1
	games_played += 1

	var scene: Node = mini_game_scenes[choice].instantiate()
	game_container.call_deferred("add_child", scene)
	Engine.time_scale = current_speed

func mini_game_won():
	current_score += 1
	current_speed += SPEED_INCREMENT
	Engine.time_scale = 1.0
	_change_scene(transition_scene)

func mini_game_lost():
	_end_game(false)

func _end_game(victory: bool):
	Engine.time_scale = 1.0
	_change_scene(win_scene if victory else loss_scene)

func go_to_main_menu():
	_change_scene(main_menu_scene)

func _change_scene(scene: PackedScene):
	_clear_game_container()
	game_container.call_deferred("add_child", scene.instantiate())

func _clear_game_container():
	for child in game_container.get_children():
		child.queue_free()
