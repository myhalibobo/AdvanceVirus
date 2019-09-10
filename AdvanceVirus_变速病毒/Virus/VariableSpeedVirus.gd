extends "res://Virus/ProtoVirus.gd"
onready var timer :Timer= $Timer
onready var animationPlayer:AnimationPlayer = $AnimationPlayer

func _ready():
	if randi()%2 == 0:
		_on_speed_up(randomf_from_to(1.5,2.5))
	else:
		_on_speed_down(randomf_from_to(2.5,3.5))
#加速
func _on_speed_up(time):
	set_velocity_scale(3)
	timer.connect("timeout",self,"_on_speed_down",[randomf_from_to(1.5,2.5)])
	timer.wait_time = time
	timer.start()
	animationPlayer.playback_speed = 4

#减速
func _on_speed_down(time):
	set_velocity_scale(1)
	timer.connect("timeout",self,"_on_speed_up",[randomf_from_to(2.5,3.5)])
	timer.wait_time = time
	timer.start()
	animationPlayer.playback_speed = 1
	
func randomf_from_to(from,to):
	return (to+randf()*(to-from))