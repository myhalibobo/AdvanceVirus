extends AnimatedSprite

func _ready():
	rotation_degrees = randi() % 360
	play("Ani")

func _on_VirusExplode_animation_finished():
	queue_free()
