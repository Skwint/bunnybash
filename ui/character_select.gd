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
	ui_signals._pop()

func _on_play_pressed():
	ui_signals._push("res://levels/level.tscn")
	

func _on_item_list_item_selected(index):
	# what sane, well adjusted programmer would put these strings in this file
	# instead of the specilizations? This is ridiculous!
	if (index == 0):
		globals.player_character = "res://mahous/undine/undine.tscn"
		desc.text = "Name: Undine Wells\nAKA: Alchemical Water\nPlay style: Bit pushy\nMouse 1: Water blast\nMouse 2: Sploosh from above\n\nJust add soap and we'll have this problem cleaned up in no time!"
	elif (index == 1):
		globals.player_character = "res://mahous/sally/sally.tscn"
		desc.text = "Name: Sally Finton\nAKA: Alchemical Fire\nPlay style: simple and direct\nMouse 1: Fireball\nMouse 2: Flames\n\nSally is the only character that kills monsters directly."
	elif (index == 2):
		globals.player_character = "res://mahous/sylvia/sylvia.tscn"
		desc.text = "Name: Sylvia Skylark\nAKA: Alchemical Air\nPlay style: good luck\nMouse 1: Air blast\nMouse 2: Whirlwind\n\nSylvia has the power of air. She has no need to fear heights."
	elif (index == 3):
		globals.player_character = "res://mahous/gwen/gwen.tscn"
		desc.text = "Name: Gwen Morita\nAKA: Alchemical Earth\nPlay style: Raaaaaah!\nMouse 1: Rock\nMouse 2: Wall\n\nGwen is physically stronger than the other alchemicals."
