extends Node

var bunny_res = preload("res://monsters/bunny.tscn")

var body
var ball
var model
var body_shape
var feet_shape

var stage : int
var stage_scales = [0.5, 1.0, 1.5, 2.0]

const fertility : float = 0.2 / 60.0
const min_ball_distance : float = 1.0
const max_ball_distance : float = 3.0
const max_ball_velocity : float = 1.5
const max_speed : float = 1.0
const ball_thrust : float = 0.05
const ball_repel : float = 0.03
const bunny_thrust : float = 0.2

# Called when the node enters the scene tree for the first time.
func _ready():
	body = get_node("body")
	ball = get_node("ball")
	model = body.get_node("model")
	body_shape = body.get_node("shape")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	var is_on_floor = false
	if body.position.y > 0.1:
		var contacts = body.get_colliding_bodies()
		for contact in contacts:
			if contact.is_in_group("floor"):
				is_on_floor = true
				break
	
	# split
	if stage == stage_scales.size() - 1:
		multiply()
	elif stage > 0:
		if randf_range(0.0, 1.0) < fertility:
			multiply()
			
	# ball thrust
	var distsq = ball.position.distance_squared_to(body.position)
	if distsq < min_ball_distance:
		ball.apply_central_impulse(ball_repel * body.position.direction_to(ball.position))
	elif distsq < max_ball_distance:
		if ball.linear_velocity.length_squared() < max_ball_velocity:
			ball.apply_central_impulse(Vector3(randf_range(-ball_thrust, ball_thrust), 0.0, randf_range(-ball_thrust, ball_thrust)))
	
	if is_on_floor:
		# turn to face ball
		body.look_at(ball.position)
		
		# drive
		var dir = body.position.direction_to(ball.position)
		var speed = body.linear_velocity.dot(dir)
		if speed < max_speed:
			body.apply_central_impulse(dir * bunny_thrust)

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
	ball.position.y = body_shape.scale.y * 0.28

func randomize():
	set_stage(randi_range(0,stage_scales.size() - 2))
	body.rotate_y(randf_range(0.0, 2.0 * PI))

func reposition(pos):
	body.set_position(pos)
	var ballpos = pos + Vector3(0.0, 0.0, 0.3).rotated(Vector3(0.0,1.0,0.0), body.get_rotation().y)
	ballpos.y = body_shape.scale.y * 0.28
	ball.set_position(ballpos)
