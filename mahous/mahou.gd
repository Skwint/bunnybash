extends RigidBody3D

var thrust : float = 250.0
var model : Node3D
var camera : Camera3D
var target : Vector3
var aim : Vector3
var reticle : Node3D
var mana : float
var max_mana : float = 1.0
var mana_regen : float = 0.05 / 60.0
var mana_bar : MeshInstance3D
var floor_damp : float = 30.0

# Called when the node enters the scene tree for the first time.
func _ready():
	model = get_node("model")
	camera = get_node("camera")
	reticle = get_node("reticle")
	mana_bar = get_node("mana_bar")
	set_mana(max_mana)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _physics_process(_delta):
	var mousePos = get_viewport().get_mouse_position()
	var origin = camera.project_ray_origin(mousePos)
	var direction = camera.project_ray_normal(mousePos)
	target = origin - direction * (origin.y / direction.y)
	reticle.global_position = target
	target.y = position.y
	aim = (target - position).normalized()
	model.look_at(target);

	var is_on_floor = false
	if position.y > 0.73:
		var contacts = get_colliding_bodies()
		for contact in contacts:
			if contact.is_in_group("floor"):
				is_on_floor = true
				break
	
	if (is_on_floor):
		linear_damp = floor_damp
		var dx = 0.0
		var dz = 0.0
		if Input.is_action_pressed("move_right"):
			dx = 1.0
		if Input.is_action_pressed("move_left"):
			dx = -1.0
		if Input.is_action_pressed("move_up"):
			dz = -1.0
		if Input.is_action_pressed("move_down"):
			dz = 1.0
		
		if dx != 0.0 and dz != 0.0:
			dx = dx * 0.707
			dz = dz * 0.707

		var ddx = 0.707 * dx + 0.707 * dz
		var ddz = 0.707 * dz - 0.707 * dx

		apply_central_force(Vector3(ddx * thrust, 0.0, ddz * thrust))
	else:
		linear_damp = 0

	if (mana < max_mana):
		set_mana(min(max_mana, mana + mana_regen))

func spawn(pos):
	position = Vector3(pos.x + 0.5, 0.75, pos.y + 0.5)
	camera.make_current()

func set_mana(value):
	mana = value
	mana_bar.scale.x = mana

