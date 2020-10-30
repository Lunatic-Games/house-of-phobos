extends Area2D


func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		interact()


func interact():
	var player = get_parent().get_parent()
	for area in get_overlapping_areas():
		area.interact(player)
