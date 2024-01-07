extends RigidBody3D

var thrust : float = 50.0
var max_speed : float = 20.0
var model : MeshInstance3D
var camera : Camera3D
var target : Vector3
var aim : Vector3
var reticle : Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	model = get_node("model")
	camera = get_node("camera")
	reticle = get_node("reticle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _physics_process(_delta):
	var mousePos = get_viewport().get_mouse_position()
	var origin = camera.project_ray_origin(mousePos)
	var direction = camera.project_ray_normal(mousePos)
	target = origin - direction * (origin.y / direction.y)
	aim = (target - position).normalized()
	reticle.global_position = target

	var is_on_floor = false
	if position.y > 0.1:
		var contacts = get_colliding_bodies()
		for contact in contacts:
			if contact.is_in_group("floor"):
				is_on_floor = true
				break
	
	if (is_on_floor):
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

		apply_central_force(Vector3(dx * thrust, 0.0, dz * thrust))


func spawn(pos):
	position = Vector3(pos.x + 0.5, 0.75, pos.y + 0.5)
	camera.make_current()
