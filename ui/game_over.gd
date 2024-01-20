extends Control

var ui_signals
var globals
var comments = [
	"Cassidy is VERY SUSPICIOUS and thinks\nyou might have been cheating",
	"Even HP is impressed",
	"Zoe thinks you're amazing",
	"Bud has seen better, but not many",
	"Rue DOES NOT LOOK LIKE BROCOLLI, alright?",
	"Tessa think you could have done better\nand aren't pulling your weight",
	"Vedika is sure you were doing your best",
	"Harley isn't sure you were doing your best",
	"You should probably try to avoid the\ngardening club girl for a day or two"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	ui_signals = get_node("/root/ui_stack_signals")
	globals = get_node("/root/globals")
	var score = globals.score
	$score_value.text = str(score)
	var index : int = (1000 - score) / 50
	index = clampi(index, 0, comments.size() - 1)
	$comment.text = comments[index]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_ok_button_pressed():
	ui_signals._pop() # this
	ui_signals._pop() # the game
	get_tree().paused = false
