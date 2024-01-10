extends RigidBody3D

const up_thrust : float = 18.0
const torque : float = 1.5
const impulse : float = 3.0
const lifetime : float = 5.0
var life : float

# Called when the node enters the scene tree for the first time.
func _ready():
	life = lifetime


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	life = life - delta
	if (life < 0):
		queue_free()

func _on_area_body_entered(body):
	body.add_constant_central_force(Vector3(0.0, up_thrust, 0.0))
	body.add_constant_torque (Vector3(0.0, torque, 0.0))

func _on_area_body_exited(body):
	body.constant_force = Vector3(0.0, 0.0, 0.0)
	body.constant_torque = Vector3(0.0, 0.0, 0.0)
	body.apply_central_impulse(Vector3(randf_range(-impulse, impulse), 0.0, randf_range(-impulse, impulse)))
