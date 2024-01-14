extends "res://mahous/mahou.gd"

var char_model_res = preload("undine.glb")
var char_model
var blorble_res = preload("blorble.tscn")
const blorble_speed : float = 7.0
var action_1_cooldown : float = 0.0
const action_1_cooldown_max : float = 1.0
var blorb : RigidBody3D
const attract_force : float = 10.0

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
	if Input.is_action_pressed("action_1") and action_1_cooldown <= 0.0:
		if (blorb != null):
			blorb.queue_free()
		blorb = blorble_res.instantiate()
		get_node("/root").add_child(blorb)
		blorb.global_transform = global_transform
		blorb.position.y = 0.5
		blorb.linear_velocity = aim * blorble_speed
		action_1_cooldown = action_1_cooldown_max
	else:
		action_1_cooldown = action_1_cooldown - delta

	if Input.is_action_pressed("action_2") and blorb != null:
		var dir = target - blorb.position
		dir.y = 0.0
		blorb.apply_central_force(dir.normalized() * attract_force)
		
