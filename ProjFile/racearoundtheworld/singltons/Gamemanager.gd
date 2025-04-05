extends Node
@export var force_mini_game: int = -1  # -1 = random as normal

const TOTAL_GAMES := 20
const MAX_REPEATS := 2
const MINI_GAME_COUNT := 5
const SPEED_INCREMENT := 0.05
var last_choice: int = -1
var repeat_count: int = 0


var game_container: Node = null
var mini_game_ids: Array[int] = []
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
		mini_game_ids.append(i)
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

	for i in mini_game_ids:
		# Disallow repeating same game too many times in a row
		if i == last_choice and repeat_count >= MAX_REPEATS:
			continue
		valid_choices.append(i)

	if valid_choices.is_empty():
		# Edge case: fallback to any mini-game (if all were blocked by repeat rule)
		valid_choices = mini_game_ids.duplicate()

	var choice := valid_choices[randi() % valid_choices.size()]

	# Track repeat count
	if choice == last_choice:
		repeat_count += 1
	else:
		repeat_count = 1
		last_choice = choice

	played_games[choice] = int(played_games.get(choice, 0)) + 1
	games_played += 1

	var game_path := "res://MiniGames/MiniGame{0}.tscn".format([choice])
	var intro_path := "res://Intros/MiniGame{0}Intro.tscn".format([choice])

	var game_scene: PackedScene = load(game_path)
	var intro_scene: PackedScene = load(intro_path)

	_show_intro_then_load_game(intro_scene, game_scene)


func _show_intro_then_load_game(intro_scene: PackedScene, game_scene: PackedScene):
	_clear_game_container()

	var intro_instance = intro_scene.instantiate()
	game_container.call_deferred("add_child", intro_instance)

	var delay := 4.0
	if intro_instance.has_method("get_delay"):
		delay = intro_instance.get_delay()

	await get_tree().create_timer(delay).timeout

	_clear_game_container()

	var game_instance = game_scene.instantiate()
	game_container.call_deferred("add_child", game_instance)
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
	if game_container:
		for child in game_container.get_children():
			child.queue_free()
