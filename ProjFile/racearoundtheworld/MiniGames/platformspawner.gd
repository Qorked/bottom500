extends Node

@export var spawn_scene: PackedScene
@export_node_path("CharacterBody2D") var player_path: NodePath

@export var total_to_spawn: int = 20
@export var vertical_spacing_min: float = 200.0
@export var vertical_spacing_max: float = 400.0
@export var min_x: float = 50.0
@export var max_x: float = 1102.0
@export var cluster_chance: float = 0.3  # 30% chance to spawn an extra platform nearby

var player: CharacterBody2D = null

func _ready():
	player = get_node_or_null(player_path)
	if not player:
		push_error("❌ Player not found for spawner.")
		return

	spawn_platforms()
	queue_free()

func spawn_platforms():
	var current_y = player.global_position.y - 300  # Start above the player

	for i in total_to_spawn:
		var base_x = randf_range(min_x, max_x)
		var spacing = randf_range(vertical_spacing_min, vertical_spacing_max)

		# Main platform
		_spawn_platform(Vector2(base_x, current_y))

		# Occasionally spawn a second platform near the same height
		if randf() < cluster_chance:
			var offset_x = randf_range(100, 200)
			var direction = 1 if randi() % 2 == 0 else -1
			var cluster_x = clamp(base_x + offset_x * direction, min_x, max_x)
			var y_variation = randf_range(-30, 30)
			_spawn_platform(Vector2(cluster_x, current_y + y_variation))

		current_y -= spacing

func _spawn_platform(position: Vector2):
	if not spawn_scene:
		push_error("⚠️ No scene assigned to spawn_scene.")
		return

	var instance = spawn_scene.instantiate()
	instance.global_position = position
	Gamemanager.game_container.add_child(instance)
