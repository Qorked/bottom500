extends CharacterBody2D

@export var move_speed: float = 100.0
@export var flee_duration: float = 0.2
@export var panic_chance: float = 0.01  # 1% chance per frame
@export var player_path: NodePath

@onready var animator: AnimationPlayer = $AnimationPlayer

var player: Node2D = null
var flee_timer: float = 0.0
var float_timer: float = 0.0

func _ready():
	randomize()

	# First try explicit path (Inspector)
	if player_path != NodePath():
		player = get_node_or_null(player_path)

	# Fallback: find any node in the 'player' group
	if not player:
		var players = get_tree().get_nodes_in_group("player")
		if players.size() > 0 and players[0] is Node2D:
			player = players[0]

	if not player:
		push_warning("⚠️ Alien couldn't find player!")

	# Spawn at random screen X/Y
	position = Vector2(randf_range(100, 1152), randf_range(100, 400))

	# Auto play animation
	if animator and animator.has_animation("fly"):
		animator.play("fly")

func _physics_process(delta: float) -> void:
	if not player:
		return

	var direction := (player.global_position - global_position).normalized()

	if randf() < panic_chance and flee_timer <= 0:
		flee_timer = flee_duration

	if flee_timer > 0:
		flee_timer -= delta
		direction = -direction  # flee!

	velocity = direction * move_speed
	move_and_slide()

	# Floaty effect
	float_timer += delta
	position.y += sin(float_timer * 2.5) * 0.3


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		Gamemanager.mini_game_lost()
