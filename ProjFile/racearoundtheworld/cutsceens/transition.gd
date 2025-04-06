extends Node2D

@onready var label: Label = $ProgressLabel

func _ready():
	# Pull progress from GameManager (if autoloaded)
	var completed = Gamemanager.current_score
	var total = Gamemanager.TOTAL_GAMES
	label.text = "Completed: %d / %d" % [completed, total]
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	
func _on_timer_timeout() -> void:
	Gamemanager._load_next_minigame()
