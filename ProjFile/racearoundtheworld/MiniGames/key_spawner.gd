extends Node2D

@export var key_scene: PackedScene
@export var spawn_x_range: Vector2 = Vector2(100, 400)
@export var spawn_y: float = 200.0  # Fixed Y position

func _ready():
	spawn_key()

func spawn_key():
	if not key_scene:
		push_error("Key scene not assigned!")
		return

	var key_instance = key_scene.instantiate()

	var random_x = randf_range(spawn_x_range.x, spawn_x_range.y)
	key_instance.global_position = Vector2(random_x, spawn_y)

	get_tree().current_scene.add_child(key_instance)
