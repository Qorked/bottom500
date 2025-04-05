extends Node2D

@export var grow_time: float = 1.0
@export var move_speed: float = 200.0
@export var final_scale: Vector2 = Vector2(1.5, 1.5)
@export var move_direction: Vector2 = Vector2(0, 1)
@export var spawn_lift: float = 30.0

var grown := false

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var area: Area2D = $Area2D  # <- Must match your node tree

func _ready():
	scale = Vector2(0.2, 0.2)

	if anim and anim.has_animation("balling"):
		anim.play("balling")

	if area:
		area.connect("area_entered", Callable(self, "_on_area_entered"))
	else:
		push_error("❌ Area2D not found on snowball!")

	var tween = create_tween()
	tween.tween_property(self, "scale", final_scale, grow_time)
	tween.tween_callback(Callable(self, "_on_grow_complete"))

func _on_grow_complete():
	grown = true

func _process(delta):
	if grown:
		position += move_direction.normalized() * move_speed * delta

func _on_area_entered(other_area: Area2D):
	if other_area.is_in_group("player"):
		print("💥 Snowball hit the player!")
		if Gamemanager:
			Gamemanager.mini_game_lost()
