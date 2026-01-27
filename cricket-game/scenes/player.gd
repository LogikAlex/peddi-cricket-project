extends CharacterBody2D

@onready var playerSprite: AnimatedSprite2D = $AnimatedSprite2D

var can_swing = false

var swung = false
var impacted = false

var impact_frame = 4
var finish_frame = 11

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("swing") and can_swing:
		swing()
	check_impact()

func swing():
	if !swung:
		swung = true
		playerSprite.play("swing")

func check_impact():
	if playerSprite.animation == "swing":
		if playerSprite.frame == impact_frame and !impacted:
			impacted = true
			print("IMPACT !!!")
		else:
			impacted = false
		
		if playerSprite.frame == finish_frame:
			playerSprite.play("idle")
