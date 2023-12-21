extends Node

var bunny_res = preload("res://monsters/bunny.tscn")

var body
var feet
var ball
var model
var body_shape
var feet_shape

var stage : int
var stage_scales = [0.5, 1.0, 1.5, 2.0]

const fertility : float = 0.1 / 60.0
const max_ball_distance : float = 3.0
const max_ball_velocity : float = 1.0
const ball_thrust : float = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	body = get_node("body")
	ball = get_node("ball")
	feet = get_node("feet")
	model = body.get_node("model")
	body_shape = body.get_node("shape")
	feet_shape = feet.get_node("shape")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	# split
	if stage == stage_scales.size() - 1:
		multiply()
	elif stage > 0:
		if randf_range(0.0, 1.0) < fertility:
			multiply()
			
	# ball thrust
	if ball.position.distance_squared_to(body.position) < max_ball_distance:
		if ball.linear_velocity.length_squared() < max_ball_velocity:
			ball.apply_central_impulse(Vector3(randf_range(-ball_thrust, ball_thrust), 0.0, randf_range(-ball_thrust, ball_thrust)))
	
	# turn to face ball

	# drive

func multiply():
	var angle = PI / 4
	var move = Vector3(0.0, 0.0, stage_scales[stage] * 0.3)
	var base_rotation : Vector3 = body.get_rotation()
	for b in 4:
		var inst
		if b == 3:
			inst = self
		else:
			inst = bunny_res.instantiate()
			get_parent().add_child(inst)
		var rot : float = base_rotation.y + angle
		inst.body.set_rotation(Vector3(base_rotation.x, rot, base_rotation.z))
		inst.reposition(body.position + move.rotated(Vector3(0.0,1.0,0.0), rot))
		inst.set_stage(stage - 1)
		angle += PI / 2

func set_stage(s):
	stage = s
	var sc = stage_scales[stage]
	var scv = Vector3(sc, sc, sc)
	model.scale = scv
	body_shape.scale = scv
	feet_shape.scale = scv

func randomize():
	set_stage(randi_range(0,stage_scales.size() - 2))
	model.rotate_y(randf_range(0.0, 2.0 * PI))

func reposition(pos):
	body.set_position(pos)
	feet.set_position(pos)
	ball.set_position(pos + Vector3(0.0, 0.0, 0.3).rotated(Vector3(0.0,1.0,0.0), body.get_rotation().y))
