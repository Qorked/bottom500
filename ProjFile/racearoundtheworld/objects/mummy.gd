extends CharacterBody2D

@export var move_distance: float = 100.0
@export var move_speed: float = 60.0
@export var wait_time: float = 0.3
@export var flip_sprite: bool = true

@onready var sprite: Sprite2D = $Sprite2D
@onready var animator: AnimationPlayer = $Sprite2D/AnimationPlayer

var origin_x: float
var direction := 1
var is_waiting := false

func _ready():
	origin_x = global_position.x

func _physics_process(_delta):
	if is_waiting:
		_play_animation("idle")
		return

	var target_x = origin_x + move_distance * direction
	var diff = target_x - global_position.x

	if abs(diff) > 1:
		velocity.x = move_speed * direction
		move_and_slide()
		_play_animation("walk")
	else:
		velocity.x = 0
		move_and_slide()
		_turn_around()

func _turn_around():
	is_waiting = true
	direction *= -1

	if flip_sprite and sprite:
		sprite.flip_h = direction < 0

	await get_tree().create_timer(wait_time).timeout
	is_waiting = false

func _play_animation(name: String):
	if animator and animator.has_animation(name):
		if animator.current_animation != name:
			animator.play(name)
