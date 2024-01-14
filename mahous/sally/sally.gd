extends "res://mahous/mahou.gd"

var char_model_res = preload("sally.glb")
var char_model
var fireball_res = preload("fireball.tscn")
const fireball_speed : float = 10.0
const fireball_cost : float = 0.05
var action_1_cooldown : float = 0.0
const action_1_cooldown_max : float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	char_model = char_model_res.instantiate()
	$model.add_child(char_model)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)


func _physics_process(delta):
	super._physics_process(delta)
	if Input.is_action_pressed("action_1") and action_1_cooldown <= 0.0 and mana >= fireball_cost:
		set_mana(mana - fireball_cost)
		var ball = fireball_res.instantiate()
		get_node("/root").add_child(ball)
		ball.global_transform = global_transform
		ball.position.y = 0.15
		ball.linear_velocity = aim * fireball_speed
		action_1_cooldown = action_1_cooldown_max
	else:
		action_1_cooldown = action_1_cooldown - delta
