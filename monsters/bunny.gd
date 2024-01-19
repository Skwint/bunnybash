extends Node

var bunny_res = preload("res://monsters/bunny.tscn")

enum State { ACTIVE, RESIZING }

var body
var ball
var model
var body_shape
var feet_shape

var stage : int = 0
var new_stage : int
var max_stage : int = 3
var stage_scale = 0.5

var state : State = State.ACTIVE
var resize_time : float = 0.0
const max_resize_time : float = 0.5

const fertility : float = 0.2 / 60.0
const min_ball_distance : float = 0.2
const med_ball_distance : float = 1.0
const max_ball_distance : float = 3.0
const max_ball_velocity : float = 1.5
const max_speed : float = 1.0
const ball_thrust : float = 0.2
const ball_repel : float = 0.03
const bunny_thrust : float = 0.2
const max_bunnies : int = 80

# Called when the node enters the scene tree for the first time.
func _ready():
	body = get_node("body")
	ball = get_node("ball")
	model = body.get_node("model")
	body_shape = body.get_node("shape")
	set_stage(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _physics_process(delta):
	if (state == State.ACTIVE):
		var is_on_floor = false
		if body.position.y > 0.1:
			var contacts = body.get_colliding_bodies()
			for contact in contacts:
				if contact.is_in_group("floor"):
					is_on_floor = true
					break
		
		# split
		if stage > 1:
			if randf_range(0.0, 1.0) < fertility * stage:
				multiply()
				
		# ball thrust
		var is_ball_close = false
		var distsq = ball.position.distance_squared_to(body.position)
		if distsq < min_ball_distance:
			is_ball_close = true
#		if distsq < med_ball_distance:
#			ball.apply_central_impulse(ball_repel * body.position.direction_to(ball.position))
		if distsq < max_ball_distance:
			var rat = ball.linear_velocity.length_squared() / max_ball_velocity
			if rat < 1.0:
				var thrust = ball_thrust * (1.0 - rat)
				ball.apply_central_impulse(Vector3(randf_range(-thrust, thrust), 0.0, randf_range(-ball_thrust, ball_thrust)))
		
		if is_on_floor:
			# turn to face ball
			body.look_at(ball.position)
			
			# drive
			if not is_ball_close:
				var dir = body.position.direction_to(ball.position)
				var speed = body.linear_velocity.dot(dir)
				if speed < max_speed:
					body.apply_central_impulse(dir * bunny_thrust)
	else: # state.RESIZING
		resize_time += delta
		if resize_time >= max_resize_time:
			rescale(1.0)
			stage = new_stage
			if (stage < 1):
				queue_free()
			else:
				state = State.ACTIVE
				ball.position.y = body_shape.scale.y * 0.28
		else:
			rescale(resize_time / max_resize_time)

func multiply():
	var angle = PI / 4
	var move = Vector3(0.0, 0.0, 0.2 * stage_scale * stage)
	var base_rotation : Vector3 = body.get_rotation()
	for b in 4:
		var inst = bunny_res.instantiate()
		get_parent().add_child(inst)
		var rot : float = base_rotation.y + angle
		inst.body.set_rotation(Vector3(base_rotation.x, rot, base_rotation.z))
		inst.reposition(body.position + move.rotated(Vector3(0.0,1.0,0.0), rot))
		inst.set_stage(stage - 1)
		angle += PI / 2
	# we could reuse this bunny but it gets complicated
	queue_free()

func set_stage(s):
	if s > max_stage:
		s = max_stage

	if s != stage:
		new_stage = s
		state = State.RESIZING
		resize_time = 0.0

func rescale(frac):
	var from = stage_scale * stage
	var to = stage_scale * new_stage
	var sc = (1 - frac) * from + frac * to
	var scv = Vector3(sc, sc, sc)
	model.scale = scv
	body_shape.scale = scv
	

func randomize():
	body.rotate_y(randf_range(0.0, 2.0 * PI))

func reposition(pos):
	body.set_position(pos)
	var ballpos = pos + Vector3(0.0, 0.0, 0.3).rotated(Vector3(0.0,1.0,0.0), body.get_rotation().y)
	ballpos.y = body_shape.scale.y * 0.28
	ball.set_position(ballpos)

func feed():
	var count = get_tree().get_nodes_in_group("monster").size()
	if count < max_bunnies:
		set_stage(stage + 1)

func kill():
	set_stage(0)
