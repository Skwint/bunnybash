extends RigidBody3D

var bunny_res = preload("res://entities/bunny.tscn")

var model
var shape

var stage : int
var stage_scales = [0.5, 1.0, 1.5, 2.0]
var fertility : float = 0.1 / 60.0

# Called when the node enters the scene tree for the first time.
func _ready():
	model = get_node("model")
	shape = get_node("shape")

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
	for b in 4:
		var bun
		if b == 3:
			bun = self
		else:
			bun = bunny_res.instantiate()
			get_parent().add_child(bun)
		bun.set_stage(stage - 1)
		bun.rotate_y(angle)
		bun.set_position(position + move.rotated(Vector3(0.0,1.0,0.0), angle))
		angle += PI / 2

func randomize():
	set_stage(randi_range(0,stage_scales.size() - 2))
	model.rotate_y(randf_range(0.0, 2.0 * PI))

func set_stage(s):
	stage = s
	var sc = stage_scales[stage]
	var scv = Vector3(sc, sc, sc)
	model.scale = scv
	shape.scale = scv
