extends Node3D

var ui_scenes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var ui_signals = get_node("/root/ui_stack_signals")
	ui_signals.pop.connect(_ui_pop)
	ui_signals.push.connect(_ui_push)
	
	ui_signals._push("res://ui/main_menu.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Remove the top level UI element from the stack and show the one below
func _ui_pop():
	var top = ui_scenes.pop_back()
	if (top != null):
		remove_child(top)
		top.call_deferred("free")
	top = ui_scenes.back()
	if (top != null):
		top.show()

# Hide the top level UI element and push a new one onto the stack
func _ui_push(scene_path):
	if (not ui_scenes.is_empty()):
		ui_scenes.back().hide()
	var new_scene_res = load(scene_path)
	var new_scene = new_scene_res.instantiate()
	ui_scenes.append(new_scene)
	add_child(new_scene)

