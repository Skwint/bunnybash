extends Control

var ui_signals
var globals

# Called when the node enters the scene tree for the first time.
func _ready():
	ui_signals = get_node("/root/ui_stack_signals")
	globals = get_node("/root/globals")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_back_pressed():
	get_tree().quit()

func _on_play_pressed():
	ui_signals._push("res://levels/level.tscn")
	

func _on_item_list_item_selected(index):
	if (index == 0):
		globals.player_character = "res://mahous/undine/undine.tscn"
	elif (index == 1):
		globals.player_character = "res://mahous/sally/sally.tscn"
	elif (index == 2):
		globals.player_character = "res://mahous/sylvia/sylvia.tscn"
	elif (index == 3):
		globals.player_character = "res://mahous/gwen/gwen.tscn"
