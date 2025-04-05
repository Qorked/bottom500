extends Node2D

@export var rotation_speed: float = 60.0
@export var gravity_tilt_strength: float = 20.0
@export var max_angle: float = 45.0

var is_game_over := false
var current_gravity_direction := 1  # 1 = right, -1 = left

func _ready():
	randomize()
	_change_gravity_direction_loop()

func _process(delta):
	if is_game_over:
		return

	# Gravity tilt in random direction
	rotation += deg_to_rad(gravity_tilt_strength * current_gravity_direction) * delta

	# Player control
	var input := 0.0
	if Input.is_action_pressed("a"):
		input -= 1.0
	if Input.is_action_pressed("d"):
		input += 1.0

	rotation += deg_to_rad(rotation_speed * input) * delta

	# Loss condition
	if abs(rad_to_deg(rotation)) > max_angle:
		print("💀 You fell!")
		is_game_over = true
		Gamemanager.mini_game_lost()

# 🌪️ Randomly changes the tilt direction every 2–3 seconds
func _change_gravity_direction_loop():
	while not is_game_over:
		await get_tree().create_timer(randf_range(2.0, 3.0)).timeout
		current_gravity_direction = -1 if randf() < 0.5 else 1
