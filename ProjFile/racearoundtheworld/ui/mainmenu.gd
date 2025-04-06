extends Control

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	

func _on_button_2_pressed() -> void:
	Gamemanager.enable_endless_mode()

func _on_button_3_pressed() -> void:
	Gamemanager.enable_hard_mode()

func _on_button_button_up() -> void:
	Gamemanager.start_game()
