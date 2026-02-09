extends Node2D

@onready var ballHitSound: AudioStreamPlayer2D = $BallHit
@onready var floorImpactSound: AudioStreamPlayer2D = $FloorImpact

@onready var player: VideoStreamPlayer = $Player2k
@onready var camera: Camera2D = $Camera2D
@onready var ball: RigidBody2D = $Ball
@onready var ballShadow: Sprite2D = $ballShadow
@onready var impactTimer: Timer = $ImpactTimer
@onready var scores: Sprite2D = $Scores
@onready var qteArea: Area2D = $QTEStartArea
@onready var hud: CanvasLayer = $HUD

@onready var blurEffect: ColorRect = $Ball.get_node("Blur")

var camera_far_right_pos: Vector2 = Vector2(180.0, 50.0)
var camera_far_left_pos: Vector2 = Vector2(-105.0, 50.0)

var launched_ball = false
var impact = false

var chance: int

func _ready() -> void:
	Globals.pressure += 0.03
	
	chance = randi_range(0, 1)
	
	Globals.canUpdateScoreArc = false
	Globals.runs = 0
	Globals.missed = false
	Globals.perfectHit = false
	Globals.earlyHit = false
	Globals.lateHit = false
	player.speed_scale = 0.0
	player.play()
	scores.modulate.a = 0
	camera.position = camera_far_left_pos

func _process(_delta: float) -> void:
	ballShadow.position.x = ball.position.x
	
	if Globals.missed:
		missed()
	
	if impact:
		impact = false
		
		qteArea.free()
		
		Globals.canUpdateScoreArc = true
		
		handleHittingBall()
		
		print("Early - " + str(Globals.earlyHit))
		print("Perfect - " + str(Globals.perfectHit))
		print("Late - " + str(Globals.lateHit))

func handleHittingBall():
	if Globals.perfectHit:
		ballHitSound.play()
		cameraShake(true)
		showScores()
		Globals.runs = 6
		Globals.score += 6
		ball.apply_impulse(Vector2(650, -235))
	if Globals.earlyHit:
		ballHitSound.play()
		cameraShake(false)
		showScores()
		if chance == 0:
			Globals.runs = 2
			Globals.score += 2
			ball.apply_impulse(Vector2(600, -100))
		if chance == 1:
			Globals.runs = 1
			Globals.score += 1
			ball.apply_impulse(Vector2(650, -35))
	if Globals.lateHit:
		ballHitSound.play()
		cameraShake(false)
		showScores()
		if chance == 1:
			Globals.runs = 4
			Globals.score += 4
			ball.apply_impulse(Vector2(650, -185))
		if chance == 0:
			Globals.runs = 3
			Globals.score += 3
			ball.apply_impulse(Vector2(580, -140))

func showScores():
	if Globals.ballsLeft > 0:
		var tween = create_tween()
		tween.tween_property(scores, "modulate:a", 1.0, 0.2).set_trans(Tween.TRANS_QUAD)
		tween.tween_callback(
		func end():
			resetLevel()
		).set_delay(2.5)
	else:
		var tween = create_tween()
		tween.tween_property(scores, "modulate:a", 1.0, 0.2).set_trans(Tween.TRANS_QUAD)
		hud.endScreen(false)

func missed():
	hud.endScreen(true)

func resetLevel():
	get_tree().reload_current_scene()

func cameraShake(isPerfect: bool):
	var camShakeTween = create_tween()
	var camMoveTween = create_tween()
	camMoveTween.set_parallel()
	camMoveTween.tween_property(camera, "position", Vector2(170.0, 50.0), 0.4).set_trans(Tween.TRANS_CUBIC)
	camMoveTween.tween_property(ball.get_node("blurred_ball"), "modulate:a", 1.0, 0.4).set_trans(Tween.TRANS_CUBIC)
	camMoveTween.tween_property(ball.get_node("blurred_ball"), "modulate:a", 0.0, 0.4).set_trans(Tween.TRANS_CUBIC).set_delay(0.4)
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
	startTween.tween_property(camera, "position", camera_far_right_pos, 0.9).set_delay(1.6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	startTween.tween_property(camera, "zoom", Vector2(0.82, 0.82), 0.5).set_delay(1.7)
	startTween.tween_callback(
	func end():
		launchBall(Vector2(-270, 50))
		Globals.ballsLeft -= 1
	).set_delay(1.0)

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

func _play_floor_sound() -> void:
	floorImpactSound.play()
