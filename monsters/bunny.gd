extends Node

var bunny_res = preload("res://monsters/bunny.tscn")

var bun
var ball
var model
var shape

var stage : int
var stage_scales = [0.5, 1.0, 1.5, 2.0]
var fertility : float = 0.1 / 60.0

# Called when the node enters the scene tree for the first time.
func _ready():
	bun = get_node("bunny")
	ball = get_node("ball")
	model = bun.get_node("model")
	shape = bun.get_node("shape")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	if stage == stage_scales.size() - 1:
		multiply()
	elif stage > 0:
		if randf_range(0.0, 1.0) < fertility:
			multiply()
			
func multiply():
	var angle = PI / 4
	var move = Vector3(0.0, 0.0, stage_scales[stage] * 0.3)
	var base_rotation : Vector3 = bun.get_rotation()
	for b in 4:
		var inst
		if b == 3:
			inst = self
		else:
			inst = bunny_res.instantiate()
			get_parent().add_child(inst)
		var rot : float = base_rotation.y + angle
		inst.bun.set_rotation(Vector3(base_rotation.x, rot, base_rotation.z))
		inst.reposition(bun.position + move.rotated(Vector3(0.0,1.0,0.0), rot))
		inst.set_stage(stage - 1)
		angle += PI / 2

func set_stage(s):
	stage = s
	var sc = stage_scales[stage]
	var scv = Vector3(sc, sc, sc)
	model.scale = scv
	shape.scale = scv

func randomize():
	set_stage(randi_range(0,stage_scales.size() - 2))
	model.rotate_y(randf_range(0.0, 2.0 * PI))

func reposition(pos):
	bun.set_position(pos)
	ball.set_position(pos + Vector3(0.0, 0.0, 0.3).rotated(Vector3(0.0,1.0,0.0), bun.get_rotation().y))
