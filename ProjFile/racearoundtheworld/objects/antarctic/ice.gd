extends Node2D

@export var fall_speed := 300.0

func _ready():
	if get_parent() != Gamemanager.game_container:
		queue_free()


func _process(delta):
	position.y += fall_speed * delta

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		print("💥 Ice hit car!")
		Gamemanager.mini_game_lost()
