extends AudioStreamPlayer2D

var space_state
var volume_scale = 1000
var volume_percentage

func make_noise(volume=1):
	var hearing_creatures = get_tree().get_nodes_in_group("hearing")
	var heard = []
	
	# Set the distance the sound can be heard
	max_distance = volume*volume_scale
	play()
	
	# Check if creatures can hear the noise
	for creature in hearing_creatures:
		var target_location = Vector2(creature.position.x, creature.position.y)
		var distance = position.distance_to(target_location)
		
		# If creature is within distance
		if distance <= get_max_distance():
			# 
			var result = space_state.intersect_ray(position, target_location)
			# TODO: Decrease volume when hitting wall
			if result:
				print("Hit at point: ", result.position)
			# Can creature still hear the sound
			if distance <= volume:
				# Creature hears noise
				volume_percentage = (distance/max_distance)
				if creature.has_method("hear_noise"):
					creature.hear_noise(volume_percentage, position)
	
func _physics_process(delta):
	space_state = get_world_2d().direct_space_state
