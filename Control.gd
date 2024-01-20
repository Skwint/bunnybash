extends Control

var ui_signals

# Called when the node enters the scene tree for the first time.
func _ready():
	ui_signals = get_node("/root/ui_stack_signals")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_exit_pressed():
	get_tree().paused = false
	ui_signals._pop()
	ui_signals._pop()


func _on_continue_pressed():
	get_tree().paused = false
	ui_signals._pop()
