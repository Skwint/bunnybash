extends RigidBody3D

const lifetime : float = 3.0
var life : float

# Called when the node enters the scene tree for the first time.
func _ready():
	life = lifetime

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	life = life - delta
	if (life < 0):
		queue_free()
