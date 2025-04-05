extends Node2D

@export var ice_scene: PackedScene
@export var spawn_interval: float = 1.0
@export var max_spawn_count: int = 20
@export var x_range: Vector2 = Vector2(0, 1152)
@export var spawn_y: float = 0.0

var spawned := 0

func _ready():
	await get_tree().process_frame  # Let the scene finish loading
	spawn_loop()


func spawn_loop():
	while spawned < max_spawn_count:
		spawn_ice()
		spawned += 1
		await get_tree().create_timer(spawn_interval).timeout

func spawn_ice():
	var ice = ice_scene.instantiate()
	var x_pos = randf_range(x_range.x, x_range.y)
	ice.position = Vector2(x_pos, spawn_y)

	if Gamemanager and Gamemanager.game_container:
		Gamemanager.game_container.add_child(ice)
	else:
		add_child(ice)  # fallback for debugging
