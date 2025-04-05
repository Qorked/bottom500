extends Node2D

func _on_timer_timeout() -> void:
	Gamemanager._load_next_minigame()
