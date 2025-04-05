extends Node2D

@export var snowball_scene: PackedScene
@export var spawn_interval: float = 1.5
@export var max_spawn_count: int = 10

@onready var path: Path2D = $Path2D
@onready var follower: PathFollow2D = $Path2D/PathFollow2D

var spawned := 0

func _ready():
	spawn_loop()

func spawn_loop():
	while spawned < max_spawn_count:
		spawn_snowball()
		spawned += 1
		await get_tree().create_timer(spawn_interval).timeout

func spawn_snowball():
	follower.progress_ratio = randf()

	var snowball = snowball_scene.instantiate()
	snowball.position = follower.global_position
	snowball.rotation = follower.rotation

	Gamemanager.game_container.add_child(snowball)
