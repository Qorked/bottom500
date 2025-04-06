extends Node2D

@export var move_speed: float = 32.0          # How fast it goes up
@export var shrink_duration: float = 10.0      # How long it takes to scale down
@export var lifetime: float = 10.0             # When to self-destruct

@onready var animator: AnimationPlayer = $CarDriving/AnimationPlayer

var time_alive := 0.0

func _ready():
	if animator and animator.has_animation("driving"):
		animator.play("driving")

	# Start shrinking the scale over time
	var shrink_tween = create_tween()
	shrink_tween.tween_property(self, "scale", Vector2.ZERO, shrink_duration)

func _process(delta):
	# Move straight up (negative y direction)
	position.y -= move_speed * delta

	# Track lifetime and delete
	time_alive += delta
	if time_alive >= lifetime:
		queue_free()
