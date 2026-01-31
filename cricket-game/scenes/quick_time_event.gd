extends Node2D

@onready var qte_outer_circle: Sprite2D = $QteIndicator
@onready var player: CharacterBody2D = $"../../player"

var start_size: Vector2 = Vector2(0.07, 0.07)
var perfect_min_size: Vector2 = Vector2(0.016, 0.016)
var perfect_max_size: Vector2 = Vector2(0.019, 0.019)
var end_size: Vector2 = Vector2(0.005, 0.005)

#tween variables
var in_tween: Tween
var out_tween: Tween

var qte_time = 0.4
var perfect_window = 0.15

var perfect_shot = false
var early_shot = false
var late_shot = false
var missed = false

func _ready() -> void:
	qte_outer_circle.modulate.a = 0
	qte_outer_circle.scale = start_size

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("swing"):
		_qte_hit()

func _qte_hit():
	in_tween.kill()
	out_tween = create_tween()
	out_tween.set_parallel()
	out_tween.tween_property(qte_outer_circle, "modulate:a", 0, 0.2)
	out_tween.tween_property(qte_outer_circle, "scale", start_size, 0.2)
	if perfect_shot:
		print("PERFECT")
		perfect_shot = true
	elif early_shot:
		print("EARLY")
		early_shot = true
	elif late_shot:
		print("LATE")
		late_shot = true
	else:
		print("MISS")

func _start_qte():
	player.swing()
	qte_outer_circle.scale = start_size
	in_tween = create_tween()
	in_tween.set_parallel()
	in_tween.tween_property($".", "early_shot", true, 0)
	in_tween.tween_property(qte_outer_circle, "modulate:a", 1, 0.2)
	in_tween.tween_property(qte_outer_circle, "scale", perfect_max_size, qte_time)
	
	in_tween.tween_property($".", "perfect_shot", true, 0).set_delay(qte_time)
	in_tween.tween_property($".", "early_shot", false, 0).set_delay(qte_time)
	
	in_tween.tween_property(qte_outer_circle, "scale", perfect_min_size, perfect_window).set_delay(qte_time)
	in_tween.tween_property(qte_outer_circle, "scale", end_size, 0.3).set_delay(qte_time + perfect_window)
	
	in_tween.tween_property($".", "perfect_shot", false, 0).set_delay(qte_time + perfect_window)
	in_tween.tween_property($".", "late_shot", true, 0).set_delay(qte_time + perfect_window)
	
	in_tween.tween_property(qte_outer_circle, "modulate:a", 0, 0.05).set_delay(qte_time + perfect_window)
	
	in_tween.tween_property(Engine, "time_scale", 1.0, 0).set_delay(qte_time + perfect_window + 0.3)
	in_tween.tween_property($".", "late_shot", false, 0).set_delay(qte_time + perfect_window + 0.15)
	in_tween.tween_property($".", "missed", true, 0).set_delay(qte_time + perfect_window + 0.15)
	
