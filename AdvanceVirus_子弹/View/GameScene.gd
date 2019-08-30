extends Node2D

func _ready():
	pass

#测试
func _on_Timer_timeout():
	VirusMgr.add_virus(500+randi()%500,randi()%3)
