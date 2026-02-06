extends CanvasLayer

@onready var countdown_label: Label = $Countdown

func _ready() -> void:
	countdown()

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
