extends Node2D

var test_location = Vector2(100, 150)
var test_volume = 100
var space_state

func calculate_distance(location, target_location):
	var y = abs(target_location.y - location.y)
	var x = abs(target_location.x - location.x)
	var distance = sqrt(x*x + y*y)
	return distance

func make_noise(volume):
	var hearing_creatures = get_tree().get_nodes_in_group("hearing")
	var heard = []
	for creature in hearing_creatures:
		var target_location = Vector2(creature.position.x, creature.position.y)
		var distance = calculate_distance(self.position, target_location)
		
		# Check all creatues in distance to hear noise
		if distance <= volume:
			# For each creature in range, do a raycast from location to their location
			var result = space_state.intersect_ray(self.position, target_location)
			# every wall hit reduces volume level
			if result:
				print("Hit at point: ", result.position)
			# compare if volume is still greater than distance
			if distance <= volume:
				# call "hear" on creature with calculated volume and location
				volume -= distance
				print(creature, "Heard the sound at volume: ", volume)
	
func _physics_process(delta):
	space_state = get_world_2d().direct_space_state
