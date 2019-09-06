extends Area2D

#var velocity = Vector2(0,0)

func _ready():
	pass

func set_velocity(velocity):
	position += velocity
	position.x = clamp(position.x,0,Utils.win_size.x)
	position.y = clamp(position.y,0,Utils.win_size.y)

func start_shoot():
	$Timer_Bullet.start()

func stop_shoot():
	$Timer_Bullet.stop()

func _on_Timer_Bullet_timeout():
	#发射子弹
	pass # Replace with function body.
