extends CharacterBody2D

@export var move_speed: float = 150.0  # Adjust for your rival speed

@onready var animator: AnimationPlayer = $AnimationPlayer

func _ready():
	if animator and animator.has_animation("driving"):
		animator.play("driving")

func _physics_process(delta: float) -> void:
	velocity.x = move_speed
	move_and_slide()
