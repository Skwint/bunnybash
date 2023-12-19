extends VBoxContainer

var ui_signals

# Called when the node enters the scene tree for the first time.
func _ready():
	ui_signals = get_node("/root/ui_stack_signals")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_btn_exit_pressed():
	get_tree().quit()


func _on_btn_help_pressed():
	ui_signals._push("res://ui/help_menu.tscn")


func _on_btn_single_player_pressed():
	ui_signals._push("res://levels/level.tscn")
