extends "res://mahous/mahou.gd"

var char_model_res = preload("sylvia.glb")
var char_model
var whirlwind_res = preload("whirlwind.tscn")
const whirlwind_speed : float = 2.0
const whirlwind_cost : float = 0.2
var action_1_cooldown : float = 0.0
const action_1_cooldown_max : float = 0.5
var action_2_cooldown : float = 0.0
const action_2_cooldown_max : float = 0.5

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
	if Input.is_action_pressed("action_2") and action_2_cooldown <= 0.0 and mana >= whirlwind_cost:
		set_mana(mana - whirlwind_cost)
		var whirl = whirlwind_res.instantiate()
		get_node("/root").add_child(whirl)
		whirl.global_transform = global_transform
		whirl.position.y = 0.15
		whirl.linear_velocity = aim * whirlwind_speed
		action_2_cooldown = action_2_cooldown_max
	else:
		action_2_cooldown = action_2_cooldown - delta
