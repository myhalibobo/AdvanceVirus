extends Node
var VirusExplodeTscn = preload("res://Effects/VirusExplode.tscn")
var BulletEffectTscn = preload("res://Effects/BulletEfc.tscn")
var color_arr
func _ready():
	color_arr = [
		Color.yellowgreen,Color.green,Color.paleturquoise,
		Color.mediumturquoise,Color.royalblue,Color.slateblue,
		Color.purple,Color.violet]

func create_bullet_hit_effect(parent,pos):
	var bullet_effect = BulletEffectTscn.instance()
	bullet_effect.position = pos
	parent.add_child(bullet_effect)
	
func create_virus_explode_effect(parent,pos,scale):
	var virus_explode = VirusExplodeTscn.instance()
	virus_explode.position = pos
	
	virus_explode.scale *= scale
	color_arr.shuffle()
	virus_explode.modulate = color_arr[0]
	
	parent.add_child(virus_explode)