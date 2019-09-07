extends Node2D

var cfg_data
var velocity
var velocity_scale = 1
var target_velocity_scale = 1
var blood setget set_blood
var ratio setget set_ratio
var radius = 110
var origin_scales
var is_dead = false
var cur_color

onready var Label_Blood = $BodyNode/Label_Blood

func _ready():
	origin_scales = $BodyNode.scale
	set_process(false)

func init_data(cfg):
	cfg_data = cfg
	velocity = cfg_data.init_velocity
	self.blood = cfg_data.blood
	self.ratio = cfg_data.scale
	set_process(true)
	
#设置血量
func set_blood(value):
	blood = clamp(value,0,cfg_data.blood)
	Label_Blood.text = str(blood)
	if blood == 0:
		#死亡
		is_dead = true
		VirusMgr.split_virus(cfg_data,position)#分裂
		VirusMgr.remove_virus_by_object(self)#remove

func take_damage(value):
	if is_dead: return
	self.blood -= value

#速度缩放
func set_velocity_scale(_scale):
	target_velocity_scale = _scale
	
#设置病毒缩放
func set_ratio(value):
	ratio = value
	$BodyNode.scale = origin_scales * value

#更新位置
func _update_position(delta): 
	#设置速度方向
	var r = radius * cfg_data.scale
	if position.y - r < 0 and velocity.y < 0:#和屏幕上方碰撞
		velocity = velocity.bounce(Vector2(0,-1))
	elif position.x - r  < 0 and velocity.x < 0:#和左边屏幕碰撞
		velocity = velocity.bounce(Vector2(1,0))
	elif position.x + r > Utils.win_size.x and velocity.x > 0:
		velocity = velocity.bounce(Vector2(-1,0))#和右边屏幕碰撞
	if position.y - radius * scale.x > Utils.win_size.y:
		position.y = ConfigMgr.virus_barth_y
	#更新病毒位置
	velocity_scale = lerp(velocity_scale,target_velocity_scale,0.05)
	var move = velocity * delta * velocity_scale
	position += move
	
#颜色更新
func _update_color():
	var color
	var color_len = int(cfg_data.topLevel_color_blood / 9)
	if blood <= color_len:
		color = Color.yellowgreen
	elif color_len < blood and 2 * color_len >= blood:
		color = Color.green
	elif 2 * color_len < blood and 3 * color_len >= blood:
		color = Color.paleturquoise
	elif 3 * color_len < blood and 4 * color_len >= blood:
		color = Color.mediumturquoise
	elif 4 * color_len < blood and 5 * color_len >= blood:
		color = Color.royalblue
	elif 5 * color_len < blood and 6 * color_len >= blood:
		color = Color.slateblue
	elif 6 * color_len < blood and 7 * color_len >= blood:
		color = Color.purple
	elif 7 * color_len < blood and 8 * color_len >= blood:
		color = Color.violet
	else:
		color = Color.crimson
	cur_color = color
	update_node_color()
	
func update_node_color():
	$BodyNode.get_node("tentacle1").modulate = cur_color
	$BodyNode.get_node("tentacle2").modulate = cur_color
	$BodyNode.get_node("body").modulate = cur_color
	
func _process(delta):
	_update_position(delta)
	_update_color()
