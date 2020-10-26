extends KinematicBody2D

const MAX_SPEED = 150
enum Tool {Flashlight, Gun}
var held_tool = Tool.Gun


func _ready():
	change_held_tool(held_tool)

func _input(event):
	if event.is_action_pressed("gun_swap"):
		change_held_tool(Tool.Gun)
	elif event.is_action_pressed("flashlight_swap"):
		change_held_tool(Tool.Flashlight)

func change_held_tool(new_tool):
	held_tool = new_tool
	for t in Tool.values():
		if t == new_tool:
			get_node("Body/" + Tool.keys()[t]).visible = true
			for raycast in get_node("Body/" + Tool.keys()[t] + "/Raycasts").get_children():
				raycast.enabled = true
		else:
			get_node("Body/" + Tool.keys()[t]).visible = false
			for raycast in get_node("Body/" + Tool.keys()[t] + "/Raycasts").get_children():
				raycast.enabled = false

func _physics_process(delta):
	rotation = global_position.direction_to(get_viewport().get_mouse_position()).angle()
	var forward_vector = Vector2(cos(rotation), sin(rotation))
	var movement: Vector2
	if Input.is_action_pressed("move_forward"):
		movement += forward_vector
	if Input.is_action_pressed("move_backward"):
		movement -= forward_vector
	if Input.is_action_pressed("strafe_left"):
		movement += forward_vector.rotated(-PI / 2)
	if Input.is_action_pressed("strafe_right"):
		movement += forward_vector.rotated(PI / 2)
	if movement.length() > 0.1:
		get_node("Body/" + Tool.keys()[held_tool] + "/AnimationPlayer").play("walk")
		$Feet/AnimationPlayer.play("walk")
	else:
		get_node("Body/" + Tool.keys()[held_tool] + "/AnimationPlayer").play("idle")
		$Feet/AnimationPlayer.play("idle")
	movement = movement.normalized() * MAX_SPEED
	move_and_slide(movement)
