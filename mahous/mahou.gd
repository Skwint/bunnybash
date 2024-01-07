extends RigidBody3D

var thrust : float = 50.0
var max_speed : float = 20.0
var model : MeshInstance3D
var camera : Camera3D

# Called when the node enters the scene tree for the first time.
func _ready():
	model = get_node("model")
	camera = get_node("camera")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _physics_process(_delta):
	var dx = 0.0
	var dz = 0.0
	if Input.is_action_pressed("move_right"):
		dx += 1.0
		dz -= 1.0
	if Input.is_action_pressed("move_left"):
		dx -= 1.0
		dz += 1.0
	if Input.is_action_pressed("move_up"):
		dx -= 1.0
		dz -= 1.0
	if Input.is_action_pressed("move_down"):
		dx += 1.0
		dz += 1.0
	
	if dx != 0.0 and dz != 0.0:
		dx *= 0.707
		dz *= 0.707
		


func spawn(pos):
	position = Vector3(pos.x + 0.5, 0.5, pos.y + 0.5)
	camera.make_current()
