extends CharacterBody2D

func _ready():
	add_to_group("key")




func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "Area2D" and area.get_parent().name == "Claw":
		print("🗝️ Key touched by claw!")
		Gamemanager.mini_game_won()
		queue_free()
