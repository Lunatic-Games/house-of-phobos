extends KinematicBody2D


const SPEED = 300
var target_location

func _physics_process(delta):
	var player = get_tree().get_nodes_in_group("player")[0]
	rotation = global_position.angle_to_point(player.global_position) + PI
	for raycast in $Raycasts.get_children():
		if raycast.is_colliding() and raycast.get_collider().is_in_group("player"):
			target_location = player.global_position
			break
	
	if target_location:
		var direction = (player.global_position - global_position).normalized()
		move_and_slide(direction * SPEED)
