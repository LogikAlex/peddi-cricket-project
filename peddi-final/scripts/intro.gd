extends Node2D

@onready var introTimer: Timer = $IntroTimer

func _ready() -> void:
	introTimer.start()

func _on_intro_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")
