extends KinematicBody2D

# Movement variables
const MAX_SPEED = 150
var joy_direction = Vector2(0.0, 0.0)
var mouse_look = false

# Tools
enum Tools {Flashlight, Gun}
var owned_tools = [Tools.Flashlight, Tools.Gun]
var held_tool = Tools.Gun
var keys = []

func _ready():
	change_held_tool(held_tool)

# Handle user presses and check for mouse movement
func _input(event):
	if event.is_action_pressed("gun_swap"):
		change_held_tool(Tools.Gun)
	elif event.is_action_pressed("flashlight_swap"):
		change_held_tool(Tools.Flashlight)
	elif event.is_action_pressed("swap"):
		change_held_tool((held_tool + 1) % len(Tools))
	if event is InputEventMouseMotion:
		mouse_look = true

func _physics_process(_delta):
	update_facing_direction()
	update_movement()

# Set previous tool body to invisible and make new tool body visible
func change_held_tool(new_tool):
	for t in Tools.values():
		get_node("Body/Top/" + Tools.keys()[t]).visible = false
	held_tool = new_tool
	get_node("Body/Top/" + Tools.keys()[held_tool]).visible = true

# Update rotation of body using mouse or right joystick
func update_facing_direction():
	var joy_movement = Vector2(Input.get_joy_axis(0, JOY_AXIS_2), Input.get_joy_axis(0, JOY_AXIS_3))
	if joy_movement.length() > 0.25:
		joy_direction += joy_movement * 0.75
		joy_direction = joy_direction.normalized()
		$Body.rotation = joy_direction.angle()
		$CollisionShape2D.rotation = $Body.rotation
		mouse_look = false
	if mouse_look:
		$Body.rotation = global_position.direction_to(get_viewport().get_mouse_position()).angle()
		$CollisionShape2D.rotation = $Body.rotation

# Update movement using keypresses or left joystick
func update_movement():
	var movement = Vector2(0, 0)
	if Input.is_action_pressed("move_up"):
		movement += Vector2(0, -1)
	if Input.is_action_pressed("move_right"):
		movement += Vector2(1, 0)
	if Input.is_action_pressed("move_down"):
		movement += Vector2(0, 1)
	if Input.is_action_pressed("move_left"):
		movement += Vector2(-1, 0)
	if movement.length() > 0.1:
		get_node("Body/Top/" + Tools.keys()[held_tool] + "/AnimationPlayer").play("walk")
		$Body/Feet/AnimationPlayer.play("walk")
	else:
		get_node("Body/Top/" + Tools.keys()[held_tool] + "/AnimationPlayer").play("idle")
		$Body/Feet/AnimationPlayer.play("idle")
	movement = movement.normalized() * MAX_SPEED
	var _ret = move_and_slide(movement)
