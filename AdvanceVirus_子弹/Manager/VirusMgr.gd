extends Node

var virus_list = []
var virus_config = [
	{speed_list=[400,300,200],ratio_list=[0.45, 0.65, 1],tscn=preload("res://virus/ProtoVirus.tscn")},
]

func _ready():
	pass # Replace with function body.

func add_virus(blood,index):
	var id = randi() % virus_config.size()
	var angle = Utils.rand_angle_range(30,150)
	var pos = Vector2(rand_range(0.2,0.8) * Utils.win_size.x,ConfigMgr.virus_barth_y)
	_create_one_virus(id,index,pos,angle,blood)
	
func _create_one_virus(id , index, pos , angle, blood):
	var config = virus_config[id]
	var virus_ins = config.tscn.instance()
	#病毒添加到父节点
	var parent = get_tree().get_root().get_node("GameScene").get_node("VirusNode")
	parent.add_child(virus_ins)
	#病毒的属性
	virus_ins.position = pos
	var scale = config.ratio_list[index]
	var speed = config.speed_list[index]
	var init_velocity = Vector2(cos(angle),sin(angle)) * speed
	var data = {
			"id":id,
			"index":index,
			"speed":speed,
			"init_velocity":init_velocity,
			"blood":blood,
			"scale":scale
			}
	virus_ins.init_data(data)
	virus_list.append(virus_ins)
