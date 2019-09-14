extends Node

var topLevel_color_blood = 1000
var virus_list = []
var virus_config = [
	{speed_list=[400,300,200],ratio_list=[0.45, 0.65, 1],tscn=preload("res://virus/ProtoVirus.tscn")},
	{speed_list=[400,300,200],ratio_list=[0.45, 0.65, 1],tscn=preload("res://Virus/VariableSpeedVirus.tscn")},
	{speed_list=[400,300,200],ratio_list=[0.45, 0.65, 1],tscn=preload("res://Virus/TreatVirue.tscn")},
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
			"scale":scale,
			"topLevel_color_blood":topLevel_color_blood
			}
	virus_ins.init_data(data)
	virus_list.append(virus_ins)
	
func split_virus(origin_data,pos):
	var split_num = 2
	var origin_blood = origin_data.blood
	var average_blood = int(origin_blood/2)
	
	for i in range(split_num):
		var id = origin_data.id
		var index = origin_data.index - 1
		var blood = 0
		if i == split_num-1:
			blood = origin_blood
		else:
			blood = average_blood
		origin_blood-=blood
		
		if index < 0:
			return
		var angle
		if i == 0:
			angle = Utils.rand_angle_range(290,340)
		elif i == 1:
			angle = Utils.rand_angle_range(200,250)
		_create_one_virus(id,index,pos,angle,blood)

func remove_virus_by_object(object):
	var index = virus_list.find(object)
	if index != -1:
		virus_list.remove(index)
		object.queue_free()
	else:
		print("重复移除")