extends CharacterBody2D


func check_for_key():
	var overlapping_areas = $Area2D.get_overlapping_areas()
	for area in overlapping_areas:
		if area.is_in_group("key"):
			print("Key grabbed!")
			get_parent().on_key_grabbed()
			area.queue_free()  # Optional: remove the key
			return
