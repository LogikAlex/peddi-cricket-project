extends Node

var userID1 = randi_range(0, 9)
var userID2 = randi_range(0, 9)
var userID3 = randi_range(0, 9)
var userID4 = randi_range(0, 9)
var userID5 = randi_range(0, 9)
var userID6 = randi_range(0, 9)
var userID7 = randi_range(0, 9)

var userID: String = str(userID1) + str(userID2) + str(userID3) + str(userID4) + str(userID5) \
+ str(userID6) + str(userID7)

var canUpdateScoreArc = false

var pressure = 0.0
var ballsLeft = 12
var runs = 0
var score = 0

var perfectHit = false
var earlyHit = false
var lateHit = false
var missed = false

var highest_score = 0
