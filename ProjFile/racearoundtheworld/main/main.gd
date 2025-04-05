extends Node

func _ready():
	# Assign GameContainer at runtime so GameManager knows where to load scenes
	Gamemanager.set_game_container($GameContainer)
	Gamemanager.go_to_main_menu()
