extends Node2D
var vs = VisualServer
var win_size
class Bullet:
	func init():
		is_free 		= false
		exclude_node 	= null

	func process(delta):
		pass
	
	var transform
	var velocity
	var exclude_node
	var is_free

	var pierce_num		#穿刺数
	var critical_rate 	#暴击率
	var pierce_rate	  	#穿刺率
	var damage			#伤害
	var speed			#速度
	
var bullet_list = []

var pierce_num = 1		#穿刺数
var critical_rate = 0 	#暴击率
var pierce_rate = 0	  	#穿刺率
var damage = 0			#伤害
var speed = 0			#速度

export(Texture) var bullet_texture

func _ready():
	win_size = get_viewport().get_visible_rect().size

func add_bullet(pos,angle):
	var b = Bullet.new()
	b.pierce_num = pierce_num
	b.critical_rate = critical_rate
	b.pierce_rate = pierce_rate
	b.damage = damage
	b.speed = speed
	b.transform = b.transform.rotated(angle)
	b.transform.orign = pos
	bullet_list.append(b)
	
func _process(delta):
	for b in bullet_list:
		pass
		#子弹是否出屏蔽
		#碰撞检测
		#移除子弹
		
func _draw():
	for b in bullet_list:
		vs.canvas_item_add_set_transform(get_canvas_item(),b.transform)
		draw_texture(bullet_texture,bullet_texture.get_size() / 2 * -1)
