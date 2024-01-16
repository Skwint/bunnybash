extends "res://mahous/mahou.gd"

var rock_ball_cost : float = 0.05
var rock_ball_res = preload("rock_ball.tscn")
const rock_ball_speed : float = 10.0
var rock_wall_res = preload("rock_wall.tscn")
var rock_wall : StaticBody3D

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	thrust = thrust * 3.5
	cdr_1_max = 0.4
	animation = $model.find_child("AnimationPlayer")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)


func _physics_process(delta):
	super._physics_process(delta)
	
func do_action_1():
	var ball = rock_ball_res.instantiate()
	get_node("/root").add_child(ball)
	ball.global_transform = global_transform
	ball.position.y = 0.15
	ball.linear_velocity = aim * rock_ball_speed

func do_action_2():
	if (rock_wall != null):
		rock_wall.queue_free()
	rock_wall = rock_wall_res.instantiate()
	get_node("/root").add_child(rock_wall)
	rock_wall.position = target
	rock_wall.look_at(target + aim)
	rock_wall.position.y = 0.5
