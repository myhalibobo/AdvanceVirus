extends Node

var win_size

func _ready():
	win_size = get_viewport().get_visible_rect().size
	
func rand_angle_range(from , to):
	return PI/180 * (randi()%int(to-from) + from)
	
func create_timer_once(wait_time,node,call_func):
	return _create_timer(wait_time,true,node,call_func)
	
func create_timer(wait_time,node,call_func):
	return _create_timer(wait_time,false,node,call_func)

func _create_timer(wait_time,is_once,node,call_func):
	var timer = Timer.new()
	node.add_child(timer)
	timer.wait_time = wait_time
	timer.one_shot = is_once
	timer.start()
	timer.connect("timeout",node,call_func)
	return timer


