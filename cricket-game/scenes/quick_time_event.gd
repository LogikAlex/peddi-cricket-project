extends Node2D

@onready var qte_outer_circle: Sprite2D = $QteIndicator
var qte_perfect_size: Vector2 = Vector2(0.013, 0.013)
var qte_min_size: Vector2 = Vector2(0.008, 0.008)
var qte_perfect_time = Globals.hit_time - Globals.pressure / 1.5
var qte_next_time = Globals.hit_time - Globals.perfect_max

var hit = false
var tween_done = false

var can_miss = true

func _ready() -> void:
	qte_outer_circle.modulate.a = 0
	#_start_qte()

func _process(_delta: float) -> void:
	if tween_done and can_miss:
		can_miss = false
		missed()

	if Input.is_action_just_pressed("swing") and !hit:
		hit = true
		qte_outer_circle.modulate.a = 1
		var tween = create_tween()
		tween.set_parallel()
		tween.tween_property(qte_outer_circle, "modulate:a", 0, 0.25).set_delay(0.15)
		tween.tween_property(qte_outer_circle, "scale", qte_outer_circle.scale - Vector2(0.02, 0.02), 0.05)
		tween.tween_property(qte_outer_circle, "scale", qte_outer_circle.scale + Vector2(0.1, 0.1), 0.3).set_delay(0.1)

func _start_qte():
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(qte_outer_circle, "modulate:a", 1, 0.2)
	tween.tween_property(qte_outer_circle, "scale", qte_perfect_size, qte_perfect_time)
	tween.tween_property(qte_outer_circle, "scale", qte_min_size, qte_next_time + 0.1).set_delay(qte_perfect_time + 0.1)
	tween.tween_callback(
	func finished():
		tween_done = true
	).set_delay(qte_perfect_time + 1.1)

func missed():
	var tween = create_tween()
	tween.tween_property(qte_outer_circle, "modulate:a", 0, 0.1)
