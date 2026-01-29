extends Node2D

@onready var qte_inner_circle: Sprite2D = $QteInnerCircle
@onready var qte_outer_circle: Sprite2D = $QteIndicator
var qte_perfect_size: Vector2 = Vector2(0.035, 0.035)
var qte_min_size: Vector2 = Vector2(0.035/2, 0.035/2)
var qte_perfect_time = Globals.hit_time
var qte_next_time = Globals.hit_time - Globals.perfect_max

var hit = false

func _ready() -> void:
	qte_outer_circle.modulate.a = 0
	#_start_qte()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("swing") and !hit:
		hit = true
		var tween = create_tween()
		tween.set_parallel()
		tween.tween_property(qte_outer_circle, "modulate:a", 0, 0.15)
		tween.tween_property(qte_outer_circle, "scale", qte_inner_circle.scale + Vector2(0.05, 0.05), 0.2)

func _start_qte():
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(qte_outer_circle, "modulate:a", 1, 0.2)
	tween.tween_property(qte_outer_circle, "scale", qte_perfect_size, qte_perfect_time)
	tween.tween_property(qte_outer_circle, "scale", qte_min_size, qte_next_time).set_delay(qte_perfect_time)
	
