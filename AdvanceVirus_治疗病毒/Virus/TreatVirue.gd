extends "res://Virus/ProtoVirus.gd"

#为其他病毒治疗
var line_texture = preload("res://Assets/Effect/line.png")

var line_virus_map = {}
var max_line_num = 3
onready var TimerTreat = $TimerTreat

func _ready():
	connect("tree_exiting",self,"_on_tree_exiting")
	TimerTreat.connect("timeout",self,"_on_treat_virus")
	TimerTreat.wait_time = 1
	TimerTreat.start()
	
	$VirusCheck.connect("area_entered",self,"_on_VirusCheck_virus_area_entered")
	$VirusCheck.connect("area_exited",self,"_on_VirusCheck_virus_area_exited")
	
func _on_VirusCheck_virus_area_entered(area):
	var virus = area.get_parent().get_parent()
	if (virus != self 
		and line_virus_map.size() <= max_line_num 
		and not is_line_binded_virus(virus)):
		create_line(virus)

func is_line_binded_virus(virus):
	var keys = line_virus_map.keys()
	#是否重新进入了我的治疗范围
	for line in keys:
		if line_virus_map[line] == virus:
			line.set_meta("connect_to_virus",true)
			return true
	return false

func create_line(virus):
	var line = Sprite.new()
	line.centered = false
	line.texture = line_texture
	line.offset.y = -line_texture.get_height() / 2
	line.scale.x = 0
	line.set_meta("connect_to_virus",true)
	var linsNode = get_node("/root/GameScene/LineNode")
	linsNode.add_child(line)
	line_virus_map[line] = virus
	
func _on_VirusCheck_virus_area_exited(area):
	var keys = line_virus_map.keys()
	var virus = area.get_parent().get_parent()
	for line in keys:
		if virus == line_virus_map[line]:
			line.set_meta("connect_to_virus",false)

func control(delta):
	var keys = line_virus_map.keys()
	for line in keys:
		var connect_to_virus = line.get_meta("connect_to_virus")
		var virus = line_virus_map[line]
		if connect_to_virus and virus.blood < virus.cfg_data.blood:
			line_connect_to_virus(virus,line)
		else:
			line.scale = line.scale.linear_interpolate(Vector2(0,1), 0.1)
			if line.scale.x < 0.05:
				line_virus_map.erase(line)
				line.queue_free()
				line = null
		if line:
			line.position = position
			line.modulate = $BodyNode.get_node("body").modulate

func line_connect_to_virus(obj,line):
	var v = obj.position - position
	line.rotation = v.angle()
	var length = v.length()
	var tx = length / line.texture.get_width()
	line.scale = line.scale.linear_interpolate(Vector2(tx,1), 0.1)

func _on_tree_exiting():
	var keys = line_virus_map.keys()
	for line in keys:
		line.queue_free()

func _on_treat_virus():
	var keys = line_virus_map.keys()
	for line in keys:
		var connect_to_virus = line.get_meta("connect_to_virus")
		if connect_to_virus:#在连接状态
			var virus = line_virus_map[line]
			if virus.blood + 50 < virus.cfg_data.blood:
				virus.blood += 50
			else:
				#治疗到满血
				virus.blood = virus.cfg_data.blood
				line.set_meta("connect_to_virus",false)