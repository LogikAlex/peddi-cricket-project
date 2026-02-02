extends Node2D

@onready var ball: RigidBody2D = $ball
@onready var start_timer: Timer = $start_timer
@onready var reset_timer: Timer = $reset_timer
@onready var countdown_label: Label = $Countdown/countdown_label
@onready var score_indicators: Node2D = $score_indicators
@onready var ball_shadow: Sprite2D = $ball_shadow

@onready var player: CharacterBody2D = $player
@onready var camera: Camera2D = $camera

@onready var ballCount: Label = $HUD.get_node("ball_count")
@onready var score: Label = $HUD.get_node("score")
@onready var runs: Label = $HUD.get_node("runs")
@onready var pressureBar: ProgressBar = $HUD.get_node("pressureBar")

var can_hit = true
var missed = false

var perfect_min = Globals.perfect_min + Globals.pressure / 2
var perfect_max = Globals.perfect_max - Globals.pressure / 2

#score ball positions
var six_ball_pos = Vector2(3910.0, 30.0)
var four_ball_pos = Vector2(3480.0, 40.0)
var three_ball_pos = Vector2(2780.0 , 44.0)
var two_ball_pos = Vector2(2270.0, 70.0)
var one_ball_pos = Vector2(1815.0, 70.0)

#camera positions
var six_cam = Vector2(3880.0, 0.0)
var four_cam = Vector2(3800.0, 0.0)
var three_cam = Vector2(2960.0, 0.0)
var two_cam = Vector2(2060.0, 0.0)
var one_cam = Vector2(2060.0, 0.0)

#quick time event variables
@onready var qte_circle: Node2D = $ball/qte_circle
@onready var qte_area: Area2D = $qte_area

func _ready() -> void:
	countdown()
	score_indicators.modulate.a = 0
	Globals.miss_chance = randi_range(0, 1)
	ball.freeze = true
	Globals.pressure += 0.01

func _process(_delta: float) -> void:
	ballCount.text = "BALL: " + str(Globals.ball_num)
	score.text = "SCORE: " + str(Globals.runs)
	
	ball_shadow.position.x = ball.position.x
	pressureBar.value = Globals.pressure
	
	if Input.is_action_just_released("ui_accept"):
		reset_level()

	hit_ball()

func countdown():
	start_timer.start()
	var countdown_tween = create_tween()
	countdown_tween.set_parallel()
	countdown_tween.tween_property(countdown_label, "text", "3", 0)
	countdown_tween.tween_property(countdown_label, "modulate:a", 0, 0.5).set_delay(0.5)
	countdown_tween.tween_property(countdown_label, "modulate:a", 1, 0).set_delay(1)
	countdown_tween.tween_property(countdown_label, "text", "2", 0).set_delay(1)
	countdown_tween.tween_property(countdown_label, "modulate:a", 0, 0.5).set_delay(1.5)
	countdown_tween.tween_property(countdown_label, "text", "1", 0).set_delay(2)
	countdown_tween.tween_property(countdown_label, "modulate:a", 1, 0).set_delay(2)
	countdown_tween.tween_property(countdown_label, "modulate:a", 0, 0.5).set_delay(2.5)
	countdown_tween.tween_property(countdown_label, "visible", false, 0).set_delay(3)
	countdown_tween.tween_property(camera, "position", Vector2(-15.0, 0.0), 3).set_delay(3).set_trans(Tween.TRANS_CUBIC)
	countdown_tween.tween_property(score_indicators, "modulate:a", 1, 0.25).set_delay(5)

func launch_ball():
	ball.freeze = false
	ball.apply_force(Vector2(-18000.0, -3000.0))
	Globals.ball_num += 1

func hit_ball():
	if player.impacted == true and can_hit:
		qte_area.free()
		can_hit = false
		Engine.time_scale = 1.0
		reset_timer.start()
		if qte_circle.perfect_shot:
			hit_perfect()
		if qte_circle.early_shot:
			hit_early()
		if qte_circle.late_shot:
			hit_late()
		if qte_circle.missed:
			pass

func change_current_runs(run_count: int):
	runs.text = "RUNS: " + str(run_count)

func hit_perfect():
	camera_shake_perfect()
	if Globals.miss_chance == 1:
		ball.apply_impulse(Vector2(380.0, -210.0), Vector2.ZERO)
		Globals.runs += 6
		change_current_runs(6)
	else:
		ball.apply_impulse(Vector2(390.0, -180.0), Vector2.ZERO)
		Globals.runs += 4
		change_current_runs(4)

func hit_early():
	camera_shake()
	if Globals.miss_chance == 1:
		ball.apply_impulse(Vector2(345.0, -100.0), Vector2.ZERO)
		Globals.runs += 1
		change_current_runs(1)
	else:
		ball.apply_impulse(Vector2(370.0, -125.0), Vector2.ZERO)
		Globals.runs += 2
		change_current_runs(2)

func hit_late():
	camera_shake()
	ball.apply_impulse(Vector2(395.0, -150.0), Vector2.ZERO)
	Globals.runs += 3
	change_current_runs(3)

func _ball_entered_qte_range(body: Node2D) -> void:
	if body.is_in_group("ball"):
		Engine.time_scale = 0.3
		qte_circle._start_qte()
		qte_circle.can_click = true

func _throw_ball() -> void:
	launch_ball()
	player.can_swing = true

func reset_level():
	get_tree().reload_current_scene()

func camera_shake():
	var shake = create_tween()
	shake.tween_property(camera, "offset", Vector2(10.0, 0.0), 0.09)
	shake.tween_property(camera, "offset", Vector2(-10.0, 0.0), 0.05)
	shake.tween_property(camera, "offset", Vector2(5.0, 0.0), 0.09)
	shake.tween_property(camera, "offset", Vector2(0.0, 0.0), 0.09)

func camera_shake_perfect():
	var shake = create_tween()
	shake.tween_property(camera, "offset", Vector2(30.0, 0.0), 0.09)
	shake.tween_property(camera, "offset", Vector2(-30.0, 0.0), 0.05)
	shake.tween_property(camera, "offset", Vector2(15.0, 0.0), 0.09)
	shake.tween_property(camera, "offset", Vector2(0.0, 0.0), 0.09)

func _on_reset_timer_timeout() -> void:
	reset_level()
