extends Node2D
var move_flag = false
onready var plane = $Plane
func _ready():
	pass

#测试
func _on_Timer_timeout():
	VirusMgr.add_virus(500+randi()%500,randi()%3)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			move_flag = true
		else:
			move_flag = false
	if event is InputEventMouseMotion and move_flag:
		plane.set_velocity(event.relative)