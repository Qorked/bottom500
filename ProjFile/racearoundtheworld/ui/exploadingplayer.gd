extends Node2D

@export var move_speed: float = 300.0
var has_collided := false

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var explosion_particles: GPUParticles2D = $GPUParticles2D
@onready var parent_ui: Node = get_parent()

func _ready():
	explosion_particles.visible = false
	explosion_particles.emitting = false

func _process(delta: float) -> void:
	if has_collided:
		return

	position.x += move_speed * delta

	# Optional: stop if close to wall manually or use Area2D detection
	# if position.x >= wall_position_x:
	#     crash_and_explode()

func crash_and_explode():
	has_collided = true
	move_speed = 0

	# Play breakdown animation first
	if anim_player.has_animation("breakdown"):
		anim_player.play("breakdown")

	await get_tree().create_timer(1.0).timeout

	# Trigger explosion
	explosion_particles.visible = true
	explosion_particles.emitting = true

	# Optionally hide the sprite (depends on breakdown effect)
	visible = false

	await get_tree().create_timer(1.2).timeout

	# Show button
	if parent_ui.has_method("_show_loss_button"):
		parent_ui.call_deferred("_show_loss_button")
