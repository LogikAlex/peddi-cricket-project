extends Node2D

@onready var ball: RigidBody2D = $ball
@onready var score_ball: RigidBody2D = $score_ball
@onready var start_timer: Timer = $start_timer
@onready var hit_timer: Timer = $hit_timer
@onready var countdown_label: Label = $countdown
@onready var score_indicators: Node2D = $score_indicators

@onready var pressureBar: ProgressBar = $pressureBar

@onready var player: CharacterBody2D = $player
@onready var camera: Camera2D = $camera

var can_hit = false

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

func _ready() -> void:
	countdown()
	score_indicators.modulate.a = 0
	Globals.miss_chance = randi_range(0, 1)
	ball.freeze = true
	Globals.pressure += 0.01

func _process(_delta: float) -> void:
	$hit_timer_value.text = str(hit_timer.time_left)
	$ball_count.text = "ball number: " + str(Globals.ball_num)
	$runs.text = "runs: " + str(Globals.runs)
	
	pressureBar.value = Globals.pressure
	
	if Input.is_action_just_released("ui_accept"):
		reset_level()

	if can_hit:
		hit_ball()

func countdown():
	start_timer.start()
	var countdown_tween = create_tween()
	countdown_tween.tween_property(countdown_label, "text", "3", 0)
	countdown_tween.tween_property(countdown_label, "text", "2", 0).set_delay(1)
	countdown_tween.tween_property(countdown_label, "text", "1", 0).set_delay(1)
	countdown_tween.tween_property(countdown_label, "visible", false, 0).set_delay(1)
	countdown_tween.tween_property(camera, "position", Vector2(0.0, 0.0), 2)
	countdown_tween.tween_property(score_indicators, "modulate:a", 1, 0.25)

func launch_ball():
	ball.freeze = false
	ball.apply_force(Vector2(-12000.0, -4500.0))
	Globals.ball_num += 1

func hit_ball():
	if player.impacted == true and hit_timer.time_left > 0.0:
		if hit_timer.time_left > perfect_min and hit_timer.time_left < perfect_max:
			#PERFECT SHOT
			camera_shake_perfect()
			if Globals.miss_chance == 1:
				ball.apply_impulse(Vector2(345.0, -185.0), Vector2.ZERO)
				tween_cam(six_cam, six_ball_pos, Vector2(30.0, 15.0))
				Globals.runs += 6
			else:
				ball.apply_impulse(Vector2(340.0, -160.0), Vector2.ZERO)
				tween_cam(four_cam, four_ball_pos, Vector2(60.0, 0.0))
				Globals.runs += 4
		if hit_timer.time_left > perfect_max and hit_timer.time_left < 0.48:
			#EARLY SHOT
			camera_shake()
			if Globals.miss_chance == 1:
				ball.apply_impulse(Vector2(315.0, -68.0), Vector2.ZERO)
				tween_cam(one_cam, one_ball_pos, Vector2(35.0, 0.0))
				Globals.runs += 1
			else:
				ball.apply_impulse(Vector2(332.0, -88.0), Vector2.ZERO)
				tween_cam(two_cam, two_ball_pos, Vector2(30.0, 10.0))
				Globals.runs += 2
		if hit_timer.time_left < perfect_min:
			#LATE SHOT
			if Globals.miss_chance == 0:
				camera_shake()
				tween_cam(three_cam, three_ball_pos, Vector2(30.0, 10.0))
				ball.apply_impulse(Vector2(375.0, -150.0), Vector2.ZERO)
				Globals.runs += 3
			else:
				pass
		can_hit = false

func _ball_entered_range(body: Node2D) -> void:
	if body.is_in_group("ball"):
		hit_timer.start()
		can_hit = true

func _ball_entered_qte_range(body: Node2D) -> void:
	if body.is_in_group("ball"):
		qte_circle._start_qte()

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

func tween_cam(cam_pos: Vector2, ball_pos: Vector2, force: Vector2):
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(score_ball, "position", ball_pos, 0)
	tween.tween_property(score_indicators, "modulate:a", 0, 0.5).set_delay(1.5)
	tween.tween_property(ball, "freeze", true, 0).set_delay(2)
	tween.tween_property(ball, "visible", false, 0).set_delay(2)
	tween.tween_property(ball.get_node("CollisionShape2D"), "disabled", true, 0).set_delay(2)
	tween.tween_property(camera, "position", cam_pos, 2).set_delay(1.8).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(score_ball, "freeze", false, 0).set_delay(2.5)
	tween.tween_property(score_ball, "visible", true, 0).set_delay(2.5)
	tween.tween_callback(
	func finish():
		score_ball.apply_impulse(force, Vector2.ZERO)
	).set_delay(2.5)

func _on_reset_timer_timeout() -> void:
	reset_level()
