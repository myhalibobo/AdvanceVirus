extends AnimatedSprite

func _ready():
	yield(get_tree(),"idle_frame")
	rotation_degrees = randi() % 360
	play("default")

func _on_VirusExplode_animation_finished():
	queue_free()
