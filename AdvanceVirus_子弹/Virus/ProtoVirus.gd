extends Node2D

var cfg_data
var velocity
var velocity_scale = Vector2(1,1)
var blood setget set_blood
var ratio setget set_ratio
var radius = 110
var origin_scales
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

func set_blood(value):
	blood = value
	Label_Blood.text = str(blood)
	
func set_ratio(value):
	ratio = value
	$BodyNode.scale = origin_scales * value

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
	var move = velocity * delta * velocity_scale
	position += move
	
func _process(delta):
	_update_position(delta)
