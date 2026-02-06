extends CharacterBody2D

@onready var playerSprite: AnimatedSprite2D = $AnimatedSprite2D

var can_swing = false

var swung = false
var impacted = false

var impact_frame = 10
var finish_frame = 12

func _process(_delta: float) -> void:
	check_impact()

func swing():
	if !swung:
		swung = true
		playerSprite.play("swing_new")

func check_impact():
	if playerSprite.animation == "swing_new":
		if playerSprite.frame == impact_frame and !impacted:
			#impacted = true
			print("IMPACT !!!")
		#else:
			#impacted = false
		
		if playerSprite.frame == finish_frame:
			playerSprite.pause()
