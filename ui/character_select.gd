extends Control

var ui_signals
var globals
var desc : RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	ui_signals = get_node("/root/ui_stack_signals")
	globals = get_node("/root/globals")
	desc = get_node("right/description")
	_on_item_list_item_selected(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_back_pressed():
	get_tree().quit()

func _on_play_pressed():
	ui_signals._push("res://levels/level.tscn")
	

func _on_item_list_item_selected(index):
	if (index == 0):
		globals.player_character = "res://mahous/undine/undine.tscn"
		desc.text = "Name: Undine Wells\nAKA: Alchemical Water\nPlay style: technical\nMouse 1: Summon blorble\nMouse 2: Control blorble"
	elif (index == 1):
		globals.player_character = "res://mahous/sally/sally.tscn"
		desc.text = "Name: Sally Finton\nAKA: Alchemical Fire\nPlay style: simple and direct\nMouse 1: Fireball\nMouse 2: Flame\nSally is the only character that kills monsters directly, which makes her by far the easiest to play."
	elif (index == 2):
		globals.player_character = "res://mahous/sylvia/sylvia.tscn"
		desc.text = "Name: Sylvia Skylark\nAKA: Alchemical Air\nPlay style: good luck\nMouse 1: Air blast\nMouse 2: Whirlwind\nSylvia has the power of air. She has no need to fear heights."
	elif (index == 3):
		globals.player_character = "res://mahous/gwen/gwen.tscn"
		desc.text = "Name: Gwen Morita\nAKA: Alchemical Earth\nPlay style: Raaaaaah!\nMouse 1: Rock\nMouse 2: Wall\nGwen is physically stronger than the other alchemicals."
