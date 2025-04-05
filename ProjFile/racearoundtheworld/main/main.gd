extends Node

func _ready():
	Gamemanager.set_game_container($GameContainer)
	print("Game container assigned:", Gamemanager.game_container)
	Gamemanager.go_to_main_menu()
