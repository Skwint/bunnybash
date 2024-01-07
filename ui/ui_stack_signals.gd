extends Node

signal pop
signal push(scene_path)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _pop():
	pop.emit()
	
func _push(scene_path):
	push.emit(scene_path)
