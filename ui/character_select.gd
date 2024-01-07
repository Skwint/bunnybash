extends Control

var ui_signals

# Called when the node enters the scene tree for the first time.
func _ready():
	ui_signals = get_node("/root/ui_stack_signals")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_back_pressed():
	get_tree().quit()

func _on_play_pressed():
	ui_signals._push("res://levels/level.tscn")
