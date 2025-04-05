extends Node2D

@export var hole_scene: PackedScene
@export var num_holes: int = 10
@export var min_spacing: float = 700.0
@export var max_spacing: float = 1300.0
@export var y_offset: float = 0.0

func _ready():
	spawn_holes()

func spawn_holes():
	var spawn_x := global_position.x

	for i in num_holes:
		spawn_x += randf_range(min_spacing, max_spacing)
		var hole = hole_scene.instantiate()
		hole.global_position = Vector2(spawn_x, global_position.y + y_offset)
		if Gamemanager and Gamemanager.game_container:
			Gamemanager.game_container.call_deferred("add_child", hole)
