extends CanvasLayer

@onready var missedOverlay: Node2D = $MissedScreen
@onready var scoreLabel: Label = $MissedScreen/Score

var pressed = false

func _on_play_button_pressed() -> void:
	$hud_normal.visible = false
	$hud_pressed_play.visible = true
	$play_button2.disabled = true
	$play_button.free()
	pressed = true

func showMissedOverlay():
	scoreLabel.text = "SCORE: " + str(Globals.runs)
	var tween = create_tween()
	tween.tween_property(missedOverlay, "modulate:a", 1, 1).set_delay(1.5)
	tween.tween_callback(
	func end():
		get_tree().reload_current_scene()
	).set_delay(3)
