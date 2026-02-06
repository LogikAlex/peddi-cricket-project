extends Node2D

@onready var player: VideoStreamPlayer = $Player
@onready var camera: Camera2D = $Camera2D
@onready var ball: RigidBody2D = $Ball
@onready var impactTimer: Timer = $ImpactTimer
@onready var scores: Sprite2D = $HUD.get_node("Scores")
@onready var qteArea: Area2D = $QTEStartArea

var camera_far_right_pos: Vector2 = Vector2(246.0, 0.0)

var launched_ball = false
var impact = false

func _ready() -> void:
	player.speed_scale = 0.0
	player.play()
	scores.modulate.a = 0
	camera.position = camera_far_right_pos

func _process(_delta: float) -> void:
	if Globals.missed:
		pass
	
	if impact:
		impact = false
		
		qteArea.free()
		
		Engine.time_scale = 1.0
		
		handleHittingBall()
		
		print("Early - " + str(Globals.earlyHit))
		print("Perfect - " + str(Globals.perfectHit))
		print("Late - " + str(Globals.lateHit))

func handleHittingBall():
	if Globals.perfectHit:
		ball.apply_impulse(Vector2(600, -350))
		cameraShake(true)
	if Globals.earlyHit:
		ball.apply_impulse(Vector2(600, -250))
		cameraShake(false)
	if Globals.lateHit:
		ball.apply_impulse(Vector2(550, -150))
		cameraShake(false)

func cameraShake(isPerfect: bool):
	var camShakeTween = create_tween()
	var camMoveTween = create_tween()
	camMoveTween.tween_property(camera, "position", Vector2(0.0, 0.0), 0.4).set_trans(Tween.TRANS_CUBIC)
	if isPerfect:
		camShakeTween.tween_property(camera, "offset", Vector2(-40, 20.0), 0.05)
		camShakeTween.tween_property(camera, "offset", Vector2(40, 0.0), 0.1)
		camShakeTween.tween_property(camera, "offset", Vector2(-20, -10.0), 0.1)
		camShakeTween.tween_property(camera, "offset", Vector2(0.0, 0.0), 0.05)
	else:
		camShakeTween.tween_property(camera, "offset", Vector2(-20, 10.0), 0.05)
		camShakeTween.tween_property(camera, "offset", Vector2(20, 0.0), 0.1)
		camShakeTween.tween_property(camera, "offset", Vector2(-10, -5.0), 0.1)
		camShakeTween.tween_property(camera, "offset", Vector2(0.0, 0.0), 0.05)

func startSequence():
	player.speed_scale = 1.0
	impactTimer.start()
	
	var startTween = create_tween()
	startTween.set_parallel()
	startTween.tween_property(camera, "position", Vector2(-75.0, 0.0), 1.0).set_trans(Tween.TRANS_CUBIC)
	startTween.tween_property(scores, "modulate:a", 1, 1.0).set_trans(Tween.TRANS_CUBIC).set_delay(4.5)
	startTween.tween_callback(
	func end():
		launchBall(Vector2(-320, 50))
	).set_delay(2)

func launchBall(impulse: Vector2):
	if !launched_ball:
		launched_ball = true
		ball.freeze = false
		ball.apply_impulse(impulse)

func _ball_entered(body: Node2D) -> void:
	if body.is_in_group("Ball"):
		ball.startQTE()

func _impact() -> void:
	impact = true
