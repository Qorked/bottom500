extends CharacterBody2D

@export var move_speed: float = 300.0
@onready var anim: AnimationPlayer = $Sprite2D/AnimationPlayer

func _ready():
	if anim and anim.has_animation("driving"):
		anim.play("driving")

func _physics_process(delta):
	var direction := 0.0
	if Input.is_action_pressed("a"):
		direction = -1.0
	elif Input.is_action_pressed("d"):
		direction = 1.0

	velocity.x = direction * move_speed
	velocity.y = 0  # ensure no gravity
	move_and_slide()
