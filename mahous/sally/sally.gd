extends "res://mahous/mahou.gd"

var fireball_res = preload("fireball.tscn")
const fireball_speed : float = 10.0

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
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
