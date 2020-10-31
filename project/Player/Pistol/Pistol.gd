extends Node2D

const MAX_DIST = 10000
const DAMAGE = 5
const KNOCKBACK = 50
const MAX_AMMO = 5
var space_state
var tracer_scene = preload("res://Player/Pistol/Tracer.tscn")
var excludes = []
var ammo = MAX_AMMO

func _physics_process(delta):
	space_state = get_world_2d().direct_space_state

func shoot(rotation):
	if ammo <= 0:
		return
	ammo -= 1
	var from = global_position
	var to = Vector2(from.x + cos(rotation) * MAX_DIST, from.y + sin(rotation) * MAX_DIST)
	var result = space_state.intersect_ray(from, to, excludes)
	if result:
		draw_tracer(from, result.position)
		if result.collider.is_in_group("monster"):
			var knockback = Vector2(cos(rotation) * KNOCKBACK, sin(rotation) * KNOCKBACK)
			result.collider.damage(DAMAGE, knockback)
	else:
		draw_tracer(from, to)

func draw_tracer(from, to):
	var tracer = tracer_scene.instance()
	tracer.points[0] = from
	tracer.points[1] = to
	get_tree().root.add_child(tracer)
