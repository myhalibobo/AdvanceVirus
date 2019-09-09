extends Sprite

func _ready():
	rotation_degrees = randi()%360
	
func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
