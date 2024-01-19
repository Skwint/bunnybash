extends "res://mahous/mahou.gd"

var whirlwind_res = preload("whirlwind.tscn")
const whirlwind_speed : float = 2.0
var airblast_res = preload("airblast.tscn")
const airblast_speed : float = 5.0

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	cdr_2_max = 2.0
	cdr_1_max = 0.5
	animation = $model.find_child("AnimationPlayer")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)


func _physics_process(delta):
	super._physics_process(delta)
	
func do_action_1():
	var whirl = airblast_res.instantiate()
	get_node("/root").add_child(whirl)
	whirl.global_transform = global_transform
	whirl.position.y = 0.0
	whirl.linear_velocity = aim * airblast_speed

func do_action_2():
	var whirl = whirlwind_res.instantiate()
	get_node("/root").add_child(whirl)
	whirl.global_transform = global_transform
	whirl.position.y = 0.15
	whirl.linear_velocity = aim * whirlwind_speed
