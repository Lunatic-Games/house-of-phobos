extends Sprite

var count = 0
var max_size
var tween

# Called when the node enters the scene tree for the first time.
func _ready():
	tween = get_node("Tween")

# player called function to use noise indicator
func set_visibility(volume_percentage):
		modulate.a = volume_percentage
		max_size = 2*volume_percentage
		tween_step(count)

func tween_step(variation):
	if variation == 0:
		tween.interpolate_property(self, "scale",
			Vector2(0, 0), Vector2(max_size, max_size), 0.6,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	if variation == 1:
		tween.interpolate_property(self, "scale", 
			Vector2(max_size,max_size), Vector2(0,0), 0.3, 
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		
	if variation == 2:
		queue_free()
	
	tween.start()


func _on_Tween_tween_completed(object, key):
	print("Complete variation", count)
	tween.stop(self)
	count += 1
	tween_step(count)
	
