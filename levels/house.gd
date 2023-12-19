extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func set_size(x, z):
	var roof = $roof_mesh
	var wall = $wall_mesh
	var coll = $CollisionShape3D
	
	roof.scale = Vector3(x, 0.2, z)
	wall.scale = Vector3(x, 9.6, z)
	coll.scale = Vector3(x, 10, z)
