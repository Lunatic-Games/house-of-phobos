extends Area2D

const HIGHLIGHT_RADIUS = 4
export (String) var key 
export (bool) var opened

func _on_Door_area_entered(area):
	if area.is_in_group("player_interact_area"):
		$StaticBody2D/Sprite.material.set_shader_param("outline_width", HIGHLIGHT_RADIUS)


func _on_Door_area_exited(area):
	if area.is_in_group("player_interact_area"):
		$StaticBody2D/Sprite.material.set_shader_param("outline_width", 0)

func interact(player):
	if !opened and (!key or player.keys.has(key)):
		$AnimationPlayer.play("open")
	if opened:
		$AnimationPlayer.play("close")
