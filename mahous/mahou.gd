extends RigidBody3D

var thrust : float = 250.0
var model : Node3D
var camera : Camera3D
var target : Vector3
var aim : Vector3
var reticle : Node3D
var max_mana : float = 1.0
var floor_damp : float = 30.0
var move_dir : Vector3
var animation : AnimationPlayer

var cdr_1 : float = 0.0
var cdr_1_max : float = 0.5
var cdr_1_bar : MeshInstance3D
var cdr_2 : float = 0.0
var cdr_2_max : float = 1.0
var cdr_2_bar : MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready():
	model = get_node("model")
	camera = get_node("camera")
	reticle = get_node("reticle")
	cdr_1_bar = get_node("cdr_1_bar")
	cdr_2_bar = get_node("cdr_2_bar")
	move_dir = Vector3(0.0, 0.0, 1.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _physics_process(delta):
	var mousePos = get_viewport().get_mouse_position()
	var origin = camera.project_ray_origin(mousePos)
	var direction = camera.project_ray_normal(mousePos)
	target = origin - direction * (origin.y / direction.y)
	reticle.global_position = target
	aim = (target - model.global_position).normalized()

	var is_on_floor = false
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
			
		if dx != 0.0 or dz != 0.0:
			move_dir.x = 0.707 * dx + 0.707 * dz
			move_dir.z = 0.707 * dz - 0.707 * dx
			apply_central_force(thrust * move_dir)
			model.look_at(model.global_position - move_dir) # back to front model
			animation.play("run")
		else:
			model.look_at(model.global_position - aim)
			if Input.is_action_pressed("action_1") or Input.is_action_pressed("action_2"):
				animation.play("cast")
			else:
				animation.play("idle")

	else:
		linear_damp = 0

	if Input.is_action_pressed("action_1") and cdr_1 <= 0.0:
		do_action_1()
		cdr_1 = cdr_1_max
	else:
		cdr_1 = max(0.0, cdr_1 - delta)
	cdr_1_bar.scale.x = cdr_1
	cdr_1_bar.scale.x = (cdr_1_max - cdr_1) / cdr_1_max

	if Input.is_action_pressed("action_2") and cdr_2 <= 0.0:
		do_action_2()
		cdr_2 = cdr_2_max
	else:
		cdr_2 = max(0.0, cdr_2 - delta)
	cdr_2_bar.scale.x = (cdr_2_max - cdr_2) / cdr_2_max
	

func spawn(pos):
	position = Vector3(pos.x + 0.5, 0.75, pos.y + 0.5)
	camera.make_current()

func do_action_1():
	pass
	
func do_action_2():
	pass
