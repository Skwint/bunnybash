extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func set_size(x, z):
	var roof = $roof_mesh
	var wall = $wall_mesh
	var coll = $shape
	
	roof.scale = Vector3(x, 1.0, z)
	wall.scale = Vector3(x, 1.0, z)
	coll.scale = Vector3(x, 1.0, z)
