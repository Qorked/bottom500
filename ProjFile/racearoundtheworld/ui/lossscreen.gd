extends Node2D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_button_pressed() -> void:
	Gamemanager.start_game()

func _on_exploading_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.call("crash_and_explode")


func _on_2button_pressed() -> void:
	Gamemanager.go_to_main_menu()
