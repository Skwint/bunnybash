extends "res://mahous/mahou.gd"

var sploosh_res = preload("sploosh.tscn")
var blorble_res = preload("blorble.tscn")
const blorble_speed : float = 7.0

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	cdr_1_max = 0.05
	cdr_2_max = 5.0
	animation = $model.find_child("AnimationPlayer")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)


func _physics_process(delta):
	super._physics_process(delta)
	
func do_action_1():
	var blorb = blorble_res.instantiate()
	get_node("/root").add_child(blorb)
	blorb.global_transform = global_transform
	blorb.position.y = 0.5
	blorb.linear_velocity = aim * blorble_speed
	blorb.look_at(blorb.global_position + aim)

func do_action_2():
	var splosh = sploosh_res.instantiate()
	splosh.position = target
	get_node("/root").add_child(splosh)
	

