extends RigidBody3D

var thrust : float = 50.0
var max_speed : float = 20.0
var model : MeshInstance3D
var feet : RigidBody3D
var motor : Generic6DOFJoint3D

# Called when the node enters the scene tree for the first time.
func _ready():
	model = get_node("model")
	feet = get_node("feet")
	motor = get_node("motor")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(delta):
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
		
	motor.set_param_x(Generic6DOFJoint3D.PARAM_ANGULAR_MOTOR_TARGET_VELOCITY, dx * max_speed)
	motor.set_param_z(Generic6DOFJoint3D.PARAM_ANGULAR_MOTOR_TARGET_VELOCITY, dz * max_speed)
	

func spawn(pos):
	position = Vector3(pos.x + 0.5, 0.5, pos.y + 0.5)
