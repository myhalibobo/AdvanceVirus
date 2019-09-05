extends Node2D
var vs = VisualServer #底层低级api主要控制渲染，Sprite就是一个壳，内部调用VisualServer实现绘制
signal bullet_collision

var win_size

class Bullet:
	func _init():
		is_free = false
		velocity = Vector2(1,1)
		transform = Transform2D()

	var transform
	var velocity
	var is_free

var bullet_list = []
var timer_bullet #射击定时器
var follower
#--------基础配置--------#
export (Texture) var bullet_texture
export (float,0,3.1415926) var bullet_angle = 0
export var bullet_space = 25	#子弹左右间隔
export var offset = Vector2(0,0)
export var shoot_angle = Vector2(0,-1)
#------子弹升级特性-------#
#->主武器等级
export var bullet_num = 5		#子弹数量 
export var damage = 1			#伤害
#->射速
export var move_speed = 3000	#移动速度 
export var shoot_space = 0.05	#射击间隔
#->穿刺
export var pierce_num = 1 		#穿刺数
export var pierce_rate = 0 		#穿刺概率
#->穿刺
export var critical_rate = 0	#暴击

var exclude_list = []
var shape_query

func _ready():
	win_size = get_viewport().get_visible_rect().size
	timer_bullet = get_node("TimerBullet")
	
func add_bullet(pos,speed,shoot_angle=Vector2(0,-1),bullet_angle=0):
	var b = Bullet.new()
	b.transform = b.transform.rotated(bullet_angle)
	b.transform.origin = pos
	b.velocity = shoot_angle * speed
	bullet_list.append(b)

func start():
	yield(get_tree(),"idle_frame")#等待一帧
	timer_bullet.wait_time = shoot_space
	timer_bullet.start()

func stop():
	timer_bullet.stop()

func _on_timer_bullet_timeout():
	if not follower: return
	var start_x = bullet_space/2 * (bullet_num-1)
	for i in range(bullet_num):
		var p = Vector2(follower.global_position.x - start_x + bullet_space * i , follower.global_position.y) + offset
		add_bullet(p,move_speed,shoot_angle,bullet_angle)

func set_shape_query(_shape_query):
	shape_query = _shape_query

func _process(delta):
	for b in bullet_list:
		#子弹是否出屏幕
		if (b.transform.origin.y < 0 ||
			b.transform.origin.y > win_size.y ||
			b.transform.origin.x < 0 ||
			b.transform.origin.x > win_size.x):
			b.is_free = true
		else:
			pass
#			var space_state = get_world_2d().get_direct_space_state()
#			var result = space_state.intersect_shape(shape_query)
#			#病毒碰撞检测
#			if result:
#				for info in result:
#					var collider = info.collider
#					pass
#
#				#计算效果
#				#发送信号
		#子弹移动
		b.transform.origin += b.velocity * delta
		
	#是否删除子弹
	var size = bullet_list.size()
	var index = size - 1
	for i in range(size):
		var b = bullet_list[index]
		if b.is_free:
			bullet_list.remove(index)
		index -= 1
	#更新绘制
	update()
	
func _draw():
	#绘制子弹，设置子弹的缩放，旋转，位置
	for b in bullet_list:
		vs.canvas_item_add_set_transform(get_canvas_item(),b.transform)
		#这个设置位置起到类似锚点作用
		var anchor = bullet_texture.get_size() / 2 * -1
		draw_texture(bullet_texture, anchor)
