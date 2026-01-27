extends Node2D

@onready var ball: RigidBody2D = $ball
@onready var start_timer: Timer = $start_timer
@onready var hit_timer: Timer = $hit_timer
@onready var countdown_label: Label = $countdown

var pressure = 0.0
var ball_num = 0

var current_state = null

enum states {IDLE, SWINGING, HIT, GAME_OVER}

func _ready() -> void:
	countdown()
	
	ball.freeze = true
	current_state = states.IDLE

func _process(_delta: float) -> void:
	$hit_timer_value.text = str(hit_timer.time_left)
	if Input.is_action_just_pressed("swing"):
		current_state = states.SWINGING
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

func hit_ball():
	ball.apply_force(Vector2(18000.0, -9300.0))

func _throw_ball() -> void:
	launch_ball()

func _missed() -> void:
	pass # Replace with function body.

func _ball_entered_range(body: Node2D) -> void:
	if body.is_in_group("ball"):
		hit_timer.start()
