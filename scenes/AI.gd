extends Node
class_name AI

@onready var AimTimer := $AimTimer as Timer
var patrolPath :PatrolPath

func _ready():
	call_deferred("setPatrolPath")
	
func setPatrolPath():
	patrolPath = get_parent().defaultPatrolPath
	
var seesPlayer = false
var doneAiming = false
var distracted = false

var targetDesination


func chooseAction():
	if seesPlayer:
		distracted = false
		if doneAiming:
			return "shoot"
		return "aim"
	elif distracted:
		return "moveOnPath"
	elif patrolPath != null:
		return "moveOnPath"
	else:
		return "idle"



func _playerEnteredVision():
	seesPlayer = true
	AimTimer.start()

func _playerExitedVision():
	seesPlayer = false
	AimTimer.stop()

func hearNoise(posNoise):
	distracted = true
	setTarget(posNoise)

func setTarget(posTarget :Vector2):
	get_parent().setTarget(posTarget)
	
func _on_aim_timer_timeout():
	doneAiming = true


func _on_target_reached():
	distracted = false
	setTarget(patrolPath.getNextPatrolPoint())
	

