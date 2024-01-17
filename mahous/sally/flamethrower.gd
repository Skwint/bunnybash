extends RigidBody3D

const lifetime : float = 0.3
var life : float

# Called when the node enters the scene tree for the first time.
func _ready():
	life = lifetime
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	life = life - delta
	if (life < 0.0):
		queue_free()

func _on_area_3d_body_entered(body):
	body.get_parent().kill()
