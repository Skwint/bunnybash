extends "res://mahous/mahou.gd"

var whirlwind_res = preload("whirlwind.tscn")
const whirlwind_speed : float = 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	cdr_2_max = 2.0
	animation = $model.find_child("AnimationPlayer")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)


func _physics_process(delta):
	super._physics_process(delta)
	
func do_action_2():
	var whirl = whirlwind_res.instantiate()
	get_node("/root").add_child(whirl)
	whirl.global_transform = global_transform
	whirl.position.y = 0.15
	whirl.linear_velocity = aim * whirlwind_speed
