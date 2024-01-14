extends "res://mahous/mahou.gd"

var char_model_res = preload("gwen.glb")
var char_model
var action_1_cooldown : float = 0.0
var action_1_cooldown_max : float = 0.4
var rock_ball_cost : float = 0.05
var rock_ball_res = preload("rock_ball.tscn")
const rock_ball_speed : float = 10.0

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	char_model = char_model_res.instantiate()
	$model.add_child(char_model)
	thrust = thrust * 3.5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)


func _physics_process(delta):
	super._physics_process(delta)
	if Input.is_action_pressed("action_1") and action_1_cooldown <= 0.0 and mana >= rock_ball_cost:
		set_mana(mana - rock_ball_cost)
		var ball = rock_ball_res.instantiate()
		get_node("/root").add_child(ball)
		ball.global_transform = global_transform
		ball.position.y = 0.15
		ball.linear_velocity = aim * rock_ball_speed
		action_1_cooldown = action_1_cooldown_max
	else:
		action_1_cooldown = action_1_cooldown - delta
