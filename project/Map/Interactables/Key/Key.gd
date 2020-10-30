extends Area2D

const HIGHLIGHT_RADIUS = 3
export (String) var opens

func _on_Key_area_entered(area):
	if area.is_in_group("player_interact_area"):
		$Sprite.material.set_shader_param("outline_width", HIGHLIGHT_RADIUS)


func _on_Key_area_exited(area):
	if area.is_in_group("player_interact_area"):
		$Sprite.material.set_shader_param("outline_width", 0)


func interact(player):
	player.keys.append(opens)
	queue_free()
