extends Node2D
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	
func _on_timer_timeout() -> void:
	Gamemanager._load_next_minigame()
