extends Node2D

@onready var ball: RigidBody2D = $ball
@onready var score_ball: RigidBody2D = $score_ball
@onready var start_timer: Timer = $start_timer
@onready var hit_timer: Timer = $hit_timer
@onready var countdown_label: Label = $countdown

@onready var player: CharacterBody2D = $player
@onready var camera: Camera2D = $camera

var can_hit = false

var perfect_min = Globals.perfect_min
var perfect_max = Globals.perfect_max

#score ball positions
var six_ball_pos = Vector2(3920.0, 44.0)
var four_ball_pos = Vector2(3480.0, 40.0)
var three_ball_pos = Vector2()
var two_ball_pos = Vector2()
var one_ball_pos = Vector2()

#camera positions
var six_cam = Vector2(3880.0, 0.0)
var four_cam = Vector2(3800.0, 0.0)
var three_cam = Vector2()
var two_cam = Vector2()
var one_cam = Vector2()

func _ready() -> void:
	countdown()
	Globals.miss_chance = randi_range(0, 1)
	ball.freeze = true

func _process(_delta: float) -> void:
	$hit_timer_value.text = str(hit_timer.time_left)
	
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

func launch_ball():
	ball.freeze = false
	ball.apply_force(Vector2(-12000.0, -4500.0))
	Globals.ball_num += 1

func hit_ball():
	if player.impacted == true and hit_timer.time_left > 0.0:
		if hit_timer.time_left > perfect_min and hit_timer.time_left < perfect_max:
			#PERFECT SHOT
			camera_shake()
			if Globals.miss_chance == 1:
				ball.apply_impulse(Vector2(345.0, -185.0), Vector2.ZERO)
				tween_cam(six_cam, six_ball_pos, Vector2(30.0, 10.0))
			else:
				ball.apply_impulse(Vector2(340.0, -160.0), Vector2.ZERO)
				tween_cam(four_cam, four_ball_pos, Vector2(60.0, 0.0))
		if hit_timer.time_left > perfect_max and hit_timer.time_left < 0.48:
			#EARLY SHOT
			tween_cam(six_cam, six_ball_pos, Vector2(30.0, 10.0))
			if Globals.miss_chance == 1:
				ball.apply_impulse(Vector2(310.0, -65.0), Vector2.ZERO)
			else:
				ball.apply_impulse(Vector2(310.0, -70.0), Vector2.ZERO)
		if hit_timer.time_left < perfect_min:
			#LATE SHOT
			if Globals.miss_chance == 0:
				ball.apply_force(Vector2(23000.0, -9000.0))
			else:
				pass
		can_hit = false

func _ball_entered_range(body: Node2D) -> void:
	if body.is_in_group("ball"):
		hit_timer.start()
		can_hit = true

func _throw_ball() -> void:
	launch_ball()
	player.can_swing = true

func reset_level():
	get_tree().reload_current_scene()

func camera_shake():
	var shake = create_tween()
	shake.tween_property(camera, "offset", Vector2(20.0, 0.0), 0.09)
	shake.tween_property(camera, "offset", Vector2(-20.0, 0.0), 0.05)
	shake.tween_property(camera, "offset", Vector2(10.0, 0.0), 0.09)
	shake.tween_property(camera, "offset", Vector2(0.0, 0.0), 0.09)

func tween_cam(cam_pos: Vector2, ball_pos: Vector2, force: Vector2):
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(ball, "freeze", true, 0).set_delay(2)
	tween.tween_property(ball, "visible", false, 0).set_delay(2)
	tween.tween_property(camera, "position", cam_pos, 2).set_delay(2)
	tween.tween_property(score_ball, "position", ball_pos, 0).set_delay(3)
	tween.tween_property(score_ball, "freeze", false, 0).set_delay(3)
	tween.tween_property(score_ball, "visible", true, 0).set_delay(3)
	tween.tween_callback(
	func finish():
		score_ball.apply_impulse(force, Vector2.ZERO)
	).set_delay(3)

func _on_reset_timer_timeout() -> void:
	reset_level()
