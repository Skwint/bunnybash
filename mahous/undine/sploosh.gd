extends Area3D

var stage : int = 0
var timer : float = 2.0 / 60.0
var impulse : float = 7.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	timer = timer - delta
	if (timer < 0.0):
		stage = stage + 1
		timer = timer + 1.0
		if (stage == 1):
			$down_particles.emitting = true
		elif (stage == 2):
			$out_particles.emitting = true
			monitoring = true
		else:
			queue_free()

func _on_body_entered(body):
	var dir = body.position - position
	body.apply_central_impulse(impulse * dir.normalized())
