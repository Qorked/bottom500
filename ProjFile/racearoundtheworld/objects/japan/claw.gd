extends CharacterBody2D

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var area: Area2D = $Area2D

var is_game_over := false
var claw_start_pos: Vector2  # Set externally by your main game script
var fail_timer: Timer        # Set externally by your main game script

func check_for_key():
	var overlapping = area.get_overlapping_areas()
	for area in overlapping:
		if area.is_in_group("key"):
			print("✅ Key detected!")

			# Preserve global position before reparenting
			var global_pos: Vector2 = area.global_position

			# Reparent to claw
			if area.get_parent():
				area.get_parent().remove_child(area)
			add_child(area)
			area.global_position = global_pos  # Keep in same place after reparent

			# Optional: Stick to center of claw visually
			# area.position = Vector2.ZERO

			anim.play("closed")
			call_deferred("on_key_grabbed_sticky", area)
			return

			

func stop_all_activity():
	set_physics_process(false)
	set_process(false)
	if anim:
		anim.stop()

func on_key_grabbed_sticky(key: Node2D):
	if is_game_over:
		return
	is_game_over = true

	if fail_timer:
		fail_timer.stop()
		
	stop_all_activity()  # ⛔ Stop movement/logic/animation

	await get_tree().create_timer(0.3).timeout

	var tween_up = create_tween()
	tween_up.tween_property(self, "position:y", claw_start_pos.y, 0.5)
	await tween_up.finished

	Gamemanager.mini_game_won()

	await get_tree().create_timer(0.1).timeout
	if is_instance_valid(self):
		queue_free()
