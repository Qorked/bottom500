extends Node

@export_node_path("Node2D") var car_path: NodePath
@onready var animator: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var win_timer: Timer = $WinTimer  # Timer node in scene

var car: Node2D = null
var is_green_light := false
var game_over := false
var did_win := false  # Track result for timer

func _ready():
	car = get_node_or_null(car_path)
	win_timer.timeout.connect(_on_WinTimer_timeout)

	animator.play("red")
	await get_tree().create_timer(3.0).timeout

	animator.play("green")
	is_green_light = true
	print("🟢 Green light! Press now!")

func _unhandled_input(event: InputEvent):
	if game_over:
		return

	if event.is_action_pressed("space"):
		game_over = true

		if car and car.has_method("drive_for"):
			car.call("drive_for", 1.0)

		if is_green_light:
			print("✅ Correct! You pressed on green.")
			did_win = true
		else:
			print("❌ You pressed during red!")
			did_win = false

		win_timer.start(1.0)

func _on_WinTimer_timeout():
	if did_win:
		Gamemanager.mini_game_won()
	else:
		Gamemanager.mini_game_lost()
