extends CharacterBody2D

# === Movement & Physics ===
@export var automove: bool = true
@export var move_speed: float = 300.0
@export var jump_velocity: float = -500.0
@export var gravity: float = 1200.0
@export var max_fall_speed: float = 1500.0
@export var allow_jump: bool = true
@export var can_double_jump: bool = false
@export var jump_action_name: String = "space"

# === Sprite & Visuals ===
@export var flip_sprite_on_direction: bool = true
@export var player_scale: Vector2 = Vector2.ONE
@export var sprite_scale_only: bool = false      

# === Optional loop settings per animation ===
@export var anim: Dictionary = {
	"driving": true,
#	"anim2": true,
#	"anim3": false,
#	"anim4": false,
#	"anim5": false
}


# === Runtime references ===
@onready var sprite: Sprite2D = $Sprite2D
@onready var animator: AnimationPlayer = $Sprite2D/AnimationPlayer

var has_double_jumped: bool = false

func _ready():
	if sprite_scale_only and sprite:
		sprite.scale = player_scale
	else:
		self.scale = player_scale

func _physics_process(delta: float) -> void:
	# === Apply gravity ===
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > max_fall_speed:
			velocity.y = max_fall_speed
	else:
		has_double_jumped = false

	# === Jumping ===
	if allow_jump and Input.is_action_just_pressed(jump_action_name):
		if is_on_floor():
			velocity.y = jump_velocity
			_play_animation("jump")
		elif can_double_jump and not has_double_jumped:
			velocity.y = jump_velocity
			has_double_jumped = true
			_play_animation("double_jump")

	# === Movement ===
	if automove:
		velocity.x = move_speed
	else:
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction != 0:
			velocity.x = direction * move_speed
			if flip_sprite_on_direction and sprite:
				sprite.flip_h = direction < 0
		else:
			velocity.x = move_toward(velocity.x, 0, move_speed)

	move_and_slide()

func _play_animation(anim: String):
	if animator and animator.has_animation(anim):
		animator.play(anim)
