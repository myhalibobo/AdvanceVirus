extends Node2D
var move_flag = false
onready var plane = $Plane
func _ready():
	pass

#测试
func _on_Timer_timeout():
	VirusMgr.add_virus(500+randi()%500,randi()%3)

var flag = false
func _protoVirusTest():
	#测试扣血
	for virus in VirusMgr.virus_list:
		virus.blood -= randi()%100
		#加减速
		if flag:
			virus.set_velocity_scale(0.1)
		else:
			virus.set_velocity_scale(1)
	flag = !flag
		

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			move_flag = true
			_protoVirusTest()
		else:
			move_flag = false
	if event is InputEventMouseMotion and move_flag:
		plane.set_velocity(event.relative)