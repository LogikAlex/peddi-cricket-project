extends Node2D

@onready var blackScreen: Sprite2D = $blackScreen

func _ready() -> void:
	fadeIn()

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func fadeIn():
	var tween = create_tween()
	tween.tween_property(blackScreen, "modulate:a", 0, 1)
