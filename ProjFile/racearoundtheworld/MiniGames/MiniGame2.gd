extends Node2D

@onready var claw: Node2D = $Claw
@onready var fail_timer: Timer = $FailTimer

@export var top_left: Vector2
@export var top_right: Vector2
@export var descend_speed: float = 100.0
@export var descend_distance: float = 200.0
@export var total_time: float = 20.0

var is_game_over := false
var is_moving := false
var is_descending := false
var direction := 1  # 1 = right, -1 = left
var claw_start_pos: Vector2


func _ready():
	claw_start_pos = claw.position
	fail_timer.wait_time = total_time
	fail_timer.start()
	_start_horizontal_movement()

func _process(delta):
	if is_moving and not is_descending:
		claw.position.x += direction * 150 * delta

		if claw.position.x >= top_right.x:
			direction = -1
		elif claw.position.x <= top_left.x:
			direction = 1

	if Input.is_action_just_pressed("space") and not is_descending and not is_game_over:
		_drop_claw()

func _drop_claw():
	is_descending = true
	is_moving = false

	var target_y = claw.position.y + descend_distance
	var tween_down = create_tween()
	tween_down.tween_property(claw, "position:y", target_y, 0.5)
	await tween_down.finished

	# check for key collision (handled by Claw.gd)
	claw.call("check_for_key")  # optional

	await get_tree().create_timer(0.3).timeout

	var tween_up = create_tween()
	tween_up.tween_property(claw, "position:y", claw_start_pos.y, 0.5)
	await tween_up.finished

	is_descending = false
	is_moving = true

func _on_fail_timer_timeout():
	if is_game_over: return
	is_game_over = true
	Gamemanager.mini_game_lost()
	queue_free()

func on_key_grabbed():
	if is_game_over: return
	is_game_over = true
	fail_timer.stop()
	Gamemanager.mini_game_won()
	queue_free()

func _start_horizontal_movement():
	is_moving = true
