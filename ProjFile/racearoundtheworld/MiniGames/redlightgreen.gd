extends Node2D

@export var move_speed: float = 600.0
var moving_time: float = 0.0  # Start at 0 = not moving

func _process(delta):
	# Check for space press (one-time press)
	if Input.is_action_just_pressed("space") and moving_time <= 0:
		moving_time = 1.0  # Move for 1 second

	# While timer is running, move forward
	if moving_time > 0.0:
		position.y -= move_speed * delta
		moving_time -= delta
