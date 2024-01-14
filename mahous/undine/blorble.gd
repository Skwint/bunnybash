extends RigidBody3D

var captured : Node
var pin : PinJoint3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(delta):
	pass

func _on_body_entered(body):
	pass

func _on_area_3d_body_entered(body):
	if (captured == null):
		captured = body.get_parent()
		captured.capture()
		pin = PinJoint3D.new()
		pin.node_a = get_path()
		pin.node_b = body.get_path()
		add_child(pin)

func _on_tree_exiting():
	if (captured != null):
		captured.release()
