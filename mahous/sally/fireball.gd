extends RigidBody3D

const lifetime : float = 3.0
var life : float
var particles : GPUParticles3D

# Called when the node enters the scene tree for the first time.
func _ready():
	particles = $particles
	life = lifetime


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(delta):
	life = life - delta
	if (life < 0):
		queue_free()


func _on_body_entered(body):
	body.get_parent().kill()
	queue_free()
