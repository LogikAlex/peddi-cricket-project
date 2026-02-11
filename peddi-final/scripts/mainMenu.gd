extends Node2D

@onready var blackScreen: Sprite2D = $blackScreen
@onready var creditsPanel: Panel = $Credits

var creditsOpened = false

func _ready() -> void:
	fadeIn()
	Globals.runs = 0
	Globals.ballsLeft = 12
	Globals.score = 0
	Globals.pressure = 0

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_credits_button_pressed() -> void:
	creditsOpened = true
	creditsPanel.visible = true

func fadeIn():
	var tween = create_tween()
	tween.tween_property(blackScreen, "modulate:a", 0, 1)

func _on_exit_credits_pressed() -> void:
	creditsOpened = false
	creditsPanel.visible = false
