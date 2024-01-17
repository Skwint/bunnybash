extends "res://mahous/mahou.gd"

var fireball_res = preload("fireball.tscn")
const fireball_speed : float = 10.0
var flamethrower_res = preload("flamethrower.tscn")
const flamethrower_speed : float = 7.0

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	cdr_2_max = 0.05
	animation = $model.find_child("AnimationPlayer")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)


func _physics_process(delta):
	super._physics_process(delta)
	
func do_action_1():
	var ball = fireball_res.instantiate()
	get_node("/root").add_child(ball)
	ball.global_transform = global_transform
	ball.position.y = 0.15
	ball.linear_velocity = aim * fireball_speed

func do_action_2():
	var flamethrower = flamethrower_res.instantiate()
	get_node("/root").add_child(flamethrower)
	flamethrower.global_transform = global_transform
	flamethrower.position.y = 0.5
	flamethrower.linear_velocity = aim * flamethrower_speed
	flamethrower.look_at(flamethrower.global_position + aim)

