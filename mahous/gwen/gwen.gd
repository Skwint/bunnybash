extends "res://mahous/mahou.gd"

var action_1_cooldown : float = 0.0
var action_1_cooldown_max : float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	thrust = thrust * 3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)


func _physics_process(delta):
	super._physics_process(delta)
	if Input.is_action_pressed("action_1") and action_1_cooldown <= 0.0:
		action_1_cooldown = action_1_cooldown_max
	else:
		action_1_cooldown = action_1_cooldown - delta
