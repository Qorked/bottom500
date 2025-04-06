extends Node

@export var force_mini_game: int = -1  # -1 = normal rotation, else fixed game index
@export var restart_delay: float = 1.0
@export var skip_intro_in_dev: bool = true

const TOTAL_GAMES := 20
const MAX_REPEATS := 2
const MINI_GAME_COUNT := 9
const SPEED_INCREMENT := 0.05

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
	if games_played >= TOTAL_GAMES and force_mini_game == -1:
		_end_game(true)
		return

	var choice: int

	if force_mini_game >= 0:
		choice = force_mini_game
	else:
		var valid_choices: Array[int] = []
		for i in mini_game_ids:
			var times_played := int(played_games.get(i, 0))
			if times_played < MAX_REPEATS:
				valid_choices.append(i)

		if valid_choices.is_empty():
			_end_game(true)
			return

		choice = valid_choices[randi() % valid_choices.size()]
		played_games[choice] = int(played_games.get(choice, 0)) + 1
		games_played += 1

	var game_path := "res://MiniGames/MiniGame%d.tscn" % choice
	var intro_path := "res://Intros/MiniGame%dIntro.tscn" % choice

	if not ResourceLoader.exists(game_path):
		push_error("Missing mini-game: " + game_path)
		return

	var game_scene: PackedScene = load(game_path)
	var intro_scene: PackedScene = null

	if ResourceLoader.exists(intro_path):
		intro_scene = load(intro_path)

	_show_intro_then_load_game(intro_scene, game_scene)

func _show_intro_then_load_game(intro_scene: PackedScene, game_scene: PackedScene):
	_clear_game_container()

	# DEV MODE: Skip intros if testing
	if force_mini_game >= 0 and skip_intro_in_dev:
		game_container.call_deferred("add_child", game_scene.instantiate())
		Engine.time_scale = current_speed
		return

	# Otherwise show intro normally
	if intro_scene:
		var intro_instance = intro_scene.instantiate()
		game_container.call_deferred("add_child", intro_instance)

		var delay := 4.0
		if intro_instance.has_method("get_delay"):
			delay = intro_instance.get_delay()

		await get_tree().create_timer(delay).timeout
		_clear_game_container()

	game_container.call_deferred("add_child", game_scene.instantiate())
	Engine.time_scale = current_speed

func mini_game_won():
	current_score += 1
	current_speed += SPEED_INCREMENT
	Engine.time_scale = 1.0

	if force_mini_game >= 0:
		print("✅ DEV MODE: Restarting game after win")
		_restart_after_delay()
	else:
		_change_scene(transition_scene)

func mini_game_lost():
	Engine.time_scale = 1.0

	if force_mini_game >= 0:
		print("❌ DEV MODE: Restarting game after loss")
		_restart_after_delay()
	else:
		_end_game(false)

func _restart_after_delay():
	await get_tree().create_timer(restart_delay).timeout
	_load_next_minigame()

func _end_game(victory: bool):
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

func _update_music_pitch():
	if not game_container:
		return

	for child in game_container.get_children():
		if child.has_node("MFX"):
			var mfx := child.get_node("MFX")
			if mfx is AudioStreamPlayer:
				mfx.pitch_scale = current_speed
