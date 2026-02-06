extends RigidBody2D

@onready var qte_current_circle: Sprite2D = $QTE/current
@onready var qte_perfect_circle: Sprite2D = $QTE/perfect

@onready var camera: Camera2D = $"../Camera2D"

var start_size: Vector2 = Vector2(0.085, 0.085)
var perfect_min_size: Vector2 = Vector2(0.033, 0.033)
var perfect_max_size: Vector2 = Vector2(0.045, 0.045)
var end_size: Vector2 = Vector2(0.01, 0.01)

var qteTween: Tween
var outTween: Tween

var qte_time = 0.6
var perfect_window = 0.15

var canClick = false

var perfect = false
var early = false
var late = false

var missed = true
var canMiss = true
var qteEnded = false

func _ready() -> void:
	qte_current_circle.scale = start_size
	qte_current_circle.modulate.a = 0
	qte_perfect_circle.modulate.a = 0

func _process(_delta: float) -> void:
	if qte_current_circle.scale <= perfect_max_size\
	and qte_current_circle.scale >= perfect_min_size:
		perfect = true
		early = false
	elif qte_current_circle.scale > perfect_max_size:
		early= true
	elif qte_current_circle.scale < perfect_min_size:
		perfect = false
		late = true
	
	checkMiss()
	
	if Input.is_action_just_pressed("swing") and canClick:
		canClick = false
		clickSwing()

func clickSwing():
	checkIfHit()
	
	qteTween.kill()
	
	outTween = create_tween()
	outTween.set_parallel()
	outTween.tween_property(qte_perfect_circle, "modulate:a", 0, 0.1)
	outTween.tween_property(qte_current_circle, "modulate:a", 0, 0.1)
	outTween.tween_property(qte_current_circle, "scale", start_size, 0.1)
	
	outTween.tween_property(camera, "zoom", Vector2(0.73, 0.73), 0.1).set_trans(Tween.TRANS_CUBIC)

func checkMiss():
	if missed and qteEnded:
		Globals.missed = true

func checkIfHit():
	if perfect:
		Globals.perfectHit = true
	if early:
		Globals.earlyHit = true
	if late:
		Globals.lateHit = true

func startQTE():
	Engine.time_scale = 0.3
	
	qteTween = create_tween()
	qteTween.set_parallel()
	
	qteTween.tween_property($".", "canClick", true, 0).set_delay(0.05)
	
	qteTween.tween_property(qte_perfect_circle, "modulate:a", 1, 0.1)
	qteTween.tween_property(qte_current_circle, "modulate:a", 1, 0.1)
	
	qteTween.tween_property(qte_current_circle, "scale", end_size, qte_time)
	qteTween.tween_property(qte_current_circle, "modulate:a", 0, 0.1).set_delay(qte_time)
	qteTween.tween_property(qte_perfect_circle, "modulate:a", 0, 0.1).set_delay(qte_time)
	qteTween.tween_property($".", "canClick", false, 0).set_delay(qte_time)
	qteTween.tween_property(camera, "zoom", Vector2(0.73, 0.73), 0.4).set_delay(qte_time).set_ease(Tween.EASE_OUT)
	qteTween.tween_property($".", "qteEnded", true, 0).set_delay(qte_time)
	
	qteTween.tween_property(camera, "zoom", Vector2(0.85, 0.85), qte_time)
	qteTween.tween_property(camera, "position", Vector2(-250, 0.0), qte_time)
	
