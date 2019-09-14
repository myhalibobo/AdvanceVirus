extends Area2D

#var velocity = Vector2(0,0)
var bullet_box 

func _ready():
	bullet_box = preload("res://Module/BulletBox.tscn").instance()
	var BulletNode = get_tree().get_root().get_node("GameScene").get_node("BulletNode")
	BulletNode.add_child(bullet_box)
	bullet_box.connect("bullet_collision",self,"_on_bullet_collision")
	bullet_box.follower = self
	bullet_box.pierce_rate = 0.1
	bullet_box.pierce_num = 2
	bullet_box.damage = 40
	start_shoot()

func set_velocity(velocity):
	position += velocity
	position.x = clamp(position.x,0,Utils.win_size.x)
	position.y = clamp(position.y,0,Utils.win_size.y)

#-----子弹-----#
func start_shoot():
	bullet_box.start()

func stop_shoot():
	bullet_box.stop()
	
func _on_bullet_collision(collider, bullet_pos,is_critical, is_pierce):
	var node = collider.get_parent().get_parent()
	if node.has_method("take_damage"):
		if is_critical:
			bullet_box.damage *=3
		node.take_damage(bullet_box.damage)
		EffectMgr.create_bullet_hit_effect(get_parent().get_node("EffectNode"),bullet_pos)
