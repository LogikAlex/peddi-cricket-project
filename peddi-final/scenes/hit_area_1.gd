extends Area2D

func _ready() -> void:
	$HitMarker.modulate.a = 0

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Ball") and Globals.canUpdateScoreArc:
		var tween = create_tween()
		$HitMarker.modulate.a = 1
		tween.tween_property($HitMarker, "modulate:a", 0.0, 0.7)
