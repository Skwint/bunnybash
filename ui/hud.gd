extends CanvasLayer

var clock_hand : TextureRect
var score_value : Label
var run_time : float = 0.0
var total_time : float = 120.0
var globals
var ui_signals

# Called when the node enters the scene tree for the first time.
func _ready():
	clock_hand = $control/clock_hand
	score_value = $control/score_value
	globals = get_node("/root/globals")
	ui_signals = get_node("/root/ui_stack_signals")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	run_time = run_time + delta
	var angle = ((run_time / total_time) * 0.66666 - 0.33333) * PI
	clock_hand.rotation = angle
	# muahaha! A load bearing view! it's a game jam get over it :p

	var score = globals.score
	score_value.text = str(score)

	if (run_time > total_time):
		ui_signals._push("res://ui/game_over.tscn")
		get_tree().paused = true
