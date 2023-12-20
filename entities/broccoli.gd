extends Node3D

enum State { SEED, GROWING, READY, SHRINKING }
var state : State = State.SEED
var model
var coll
var grow_time : float = 0.0
const max_grow_time : float = 2.0
const max_scale : float = 0.14
const fertility : float = 0.1 / 60.0

# Called when the node enters the scene tree for the first time.
func _ready():
	model = get_node("model")
	model.scale = Vector3(0.01, 0.01, 0.01)
	model.visible = false
	coll = get_node("shape")
	coll.disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	if state == State.SEED:
		if (randf_range(0.0, 1.0) < fertility):
			model.visible = true
			state = State.GROWING
			coll.disabled = true
			grow_time = 0.0
			model.rotate_y(randf_range(0.0, 2.0 * PI))
	elif state == State.GROWING:
		grow_time += delta
		if grow_time >= max_grow_time:
			model.scale = Vector3(max_scale, max_scale, max_scale)
			coll.disabled = false
			state = State.READY
		else:
			var sc = max_scale * grow_time / max_grow_time
			model.scale = Vector3(sc, sc, sc)

