extends CanvasLayer

@onready var countdown_label: Label = $Countdown
@onready var leftBar: Sprite2D = $BlackBars/BlackBar2
@onready var rightBar: Sprite2D = $BlackBars/BlackBar3
@onready var endScreenNode: Node2D = $EndScreen

@onready var ballsLeft: Label = $downHUD/Balls
@onready var score: Label = $downHUD/Score
@onready var runs: Label = $downHUD/Runs

var leftBarEndPos: Vector2 = Vector2(85.5, 360.0)
var rightBarEndPos: Vector2 = Vector2(1194.5, 360.0)

func _process(_delta: float) -> void:
	endScreenNode.get_node("Score").text = "Score: " + str(Globals.score)
	ballsLeft.text = "BALLS LEFT: " + str(Globals.ballsLeft)
	runs.text = "RUNS: " + str(Globals.runs)
	score.text = "SCORE: " + str(Globals.score)

func _ready() -> void:
	countdown()
	endScreenNode.modulate.a = 0
	#blackBarsAppear()

func countdown():
	var countdown_tween = create_tween()
	countdown_tween.set_parallel()
	countdown_tween.tween_property(countdown_label, "modulate:a", 1, 0)
	countdown_tween.tween_property(countdown_label, "text", "3", 0)
	countdown_tween.tween_property(countdown_label, "modulate:a", 0, 0.5).set_delay(0.5)
	countdown_tween.tween_property(countdown_label, "modulate:a", 1, 0).set_delay(1)
	countdown_tween.tween_property(countdown_label, "text", "2", 0).set_delay(1)
	countdown_tween.tween_property(countdown_label, "modulate:a", 0, 0.5).set_delay(1.5)
	countdown_tween.tween_property(countdown_label, "text", "1", 0).set_delay(2)
	countdown_tween.tween_property(countdown_label, "modulate:a", 1, 0).set_delay(2)
	countdown_tween.tween_property(countdown_label, "modulate:a", 0, 0.5).set_delay(2.5)
	countdown_tween.tween_property(countdown_label, "visible", false, 0).set_delay(3)
	
	countdown_tween.tween_callback(
	func start():
		$"..".startSequence()
	).set_delay(3)

func endScreen(missed: bool):
	var tween = create_tween()
	tween.tween_property(endScreenNode, "modulate:a", 1, 1).set_delay(1.5)
	if missed:
		endScreenNode.get_node("Missed").visible = true
	else:
		endScreenNode.get_node("Over").visible = true
	tween.tween_callback(
	func reset():
		get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")
	).set_delay(4)

func blackBarsAppear():
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(leftBar, "position", leftBarEndPos, 1.5).set_trans(Tween.TRANS_CUBIC).set_delay(3)
	tween.tween_property(rightBar, "position", rightBarEndPos, 1.5).set_trans(Tween.TRANS_CUBIC).set_delay(3)

func _on_swing_button_pressed() -> void:
	Input.action_press("swing")
