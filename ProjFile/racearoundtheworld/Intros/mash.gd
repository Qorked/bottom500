extends CharacterBody2D

@export var mash_key: String = "space"
@export var mash_power_increase: float = 1.0
@export var mash_decay: float = 0.95
@export var max_speed: float = 1000.0
@export var win_x_position: float = 3000.0
var time_elapsed: float = 0.0

var is_game_over: bool = false
var mash_power: float = 0.0
var current_speed: float = 0.0

@onready var animator: AnimationPlayer = $Sprite2D/AnimationPlayer

func _ready():
	if animator and animator.has_animation("driving"):
		animator.play("driving")

func _physics_process(delta):
	if is_game_over:
		return

	time_elapsed += delta

	if Input.is_action_just_pressed(mash_key):
		mash_power += mash_power_increase

	mash_power *= mash_decay

	var raw_speed = pow(mash_power, 1.5)
	current_speed = clamp(raw_speed * time_elapsed, 0, max_speed)

	velocity.x = current_speed
	move_and_slide()

	if position.x >= win_x_position:
		is_game_over = true
		Gamemanager.mini_game_won()
