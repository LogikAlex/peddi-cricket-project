extends Node2D

@onready var ball: RigidBody2D = $ball
@onready var start_timer: Timer = $start_timer
@onready var hit_timer: Timer = $hit_timer
@onready var countdown_label: Label = $countdown

@onready var player: CharacterBody2D = $player
@onready var camera: Camera2D = $camera

var can_hit = false

var perfect_min = Globals.perfect_min
var perfect_max = Globals.perfect_max

func _ready() -> void:
	countdown()
	Globals.miss_chance = randi_range(0, 1)
	ball.freeze = true

func _process(_delta: float) -> void:
	_check_miss()
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
	if player.impacted == true and hit_timer.time_left > 0:
		if hit_timer.time_left > perfect_min and hit_timer.time_left < perfect_max:
			camera_shake()
			#ball.position = Vector2(-458.0, 228.0)
			ball.apply_force(Vector2(19600.0, -11000.0))
		if hit_timer.time_left > perfect_max:
			#ball.position = Vector2(-458.0, 228.0)
			if Globals.miss_chance == 1:
				ball.apply_force(Vector2(16000.0, -4300.0))
			else:
				ball.apply_force(Vector2(12000.0, -3700.0))
		if hit_timer.time_left < perfect_min:
			if Globals.miss_chance == 0:
				#ball.position = Vector2(-458.0, 228.0)
				ball.apply_force(Vector2(23000.0, -6000.0))
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

func _check_miss() -> void:
	if hit_timer.time_left == 0 and can_hit:
		can_hit = false
		$reset_timer.start()

func reset_level():
	get_tree().reload_current_scene()

func camera_shake():
	var shake = create_tween()
	shake.tween_property(camera, "offset", Vector2(20.0, 0.0), 0.09)
	shake.tween_property(camera, "offset", Vector2(-20.0, 0.0), 0.05)
	shake.tween_property(camera, "offset", Vector2(10.0, 0.0), 0.09)
	shake.tween_property(camera, "offset", Vector2(0.0, 0.0), 0.09)

func _on_reset_timer_timeout() -> void:
	reset_level()
