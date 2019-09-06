extends Node2D
var vs = VisualServer #底层低级api主要控制渲染，Sprite就是一个壳，内部调用VisualServer实现绘制
signal bullet_collision

var win_size

class Bullet:
	var transform = Transform2D()
	var velocity = Vector2(1,1)
	
	var damage = 0			#伤害
	var pierce_num = 0 		#穿刺数
	var pierce_rate = 0 	#穿刺概率
	var critical_rate = 0	#暴击
	
	var is_free = false
	var exclude_list = []

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

#碰撞查询
var query_shape
var query_para
enum INSTYPE{
	VIRUES = 1,
	PLANE = 2,
}

export(bool) var is_collide_with_areas = true
export(bool) var is_collide_with_bodies = false
export(INSTYPE) var collision_layer = INSTYPE.VIRUES

func _ready():
	win_size = get_viewport().get_visible_rect().size
	timer_bullet = get_node("TimerBullet")
	_init_query_para()
	
func add_bullet(pos,speed,shoot_angle=Vector2(0,-1),bullet_angle=0):
	var b = Bullet.new()
	b.transform = b.transform.rotated(bullet_angle)
	b.transform.origin = pos
	b.velocity = shoot_angle * speed
	b.pierce_num = pierce_num
	b.critical_rate = critical_rate
	b.damage = damage
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

func _init_query_para():
	query_shape = CircleShape2D.new()
	query_shape.radius = bullet_texture.get_size().x
	query_para = Physics2DShapeQueryParameters.new()
	query_para.collision_layer = 1
	query_para.collide_with_areas = is_collide_with_areas
	query_para.collide_with_bodies = is_collide_with_bodies
	query_para.set_shape(query_shape)

func _collision_detech(b):
	query_para.transform = b.transform
	var space_state = get_world_2d().get_direct_space_state()  
	var result = space_state.intersect_shape(query_para,3)
	if result:
		return result
	return false
			
			
func chack_rate(rate):
	var value = randi() % 10000 + 1;
	if value <= int(rate * 10000):
		return true
	return false
	
func _process(delta):
	for b in bullet_list:
		#子弹是否出屏幕
		if (b.transform.origin.y < 0 ||
			b.transform.origin.y > win_size.y ||
			b.transform.origin.x < 0 ||
			b.transform.origin.x > win_size.x):
			b.is_free = true
		else:
			var result = _collision_detech(b)
			if result:
				for info in result:
					var collider = info.collider
					if not b.exclude_list.has(collider):
						#穿刺处理
						var is_pierce = chack_rate(b.pierce_rate)
						if is_pierce :
							if b.pierce_num > 0:
								b.pierce_num -= 1
								b.exclude_list.append(collider)
						var is_critical = chack_rate(b.critical_rate)
						emit_signal("bullet_collision",collider,is_critical,is_pierce)
						if not is_pierce or b.pierce_num == 0:
							b.is_free = true
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
