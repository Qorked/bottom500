extends Control

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)



func _on_l_pressed() -> void:
	Gamemanager.start_game()
