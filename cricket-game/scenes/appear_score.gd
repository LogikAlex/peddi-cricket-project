extends Area2D

@export var wantedFrame: int
@export var score_indicators: Node2D
@export var player: CharacterBody2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("ball") and player.swung:
		score_indicators.get_node("Scores").frame = wantedFrame
