extends Node
class_name AI

@onready var AimTimer := $AimTimer as Timer
var patrolPath :PatrolPath


var seesPlayer = false
var doneAiming = false
var distracted = false

var targetDesination


func _ready():
	call_deferred("setPatrolPath")
	
func setPatrolPath():
	if get_parent().defaultPatrolPath != null:
		patrolPath = get_parent().defaultPatrolPath
		setTarget(patrolPath.getNextPatrolPoint())
		
func chooseAction():
	if seesPlayer:
		distracted = false
		if doneAiming:
			
			doneAiming = false
			return "shoot"
		return "aim"
	elif distracted:
		return "moveOnPath"
	elif patrolPath != null:
		return "moveOnPath"
	else:
		return "idle"
		



func _playerEnteredVision():
	if not get_parent().player.isInShadow:
		seesPlayer = true
	AimTimer.start()

func _playerExitedVision():
	seesPlayer = false
	if not get_parent().player.isInShadow:
		hearNoise(get_parent().player.position)
	
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
	if get_parent().defaultPatrolPath != null:
		setTarget(patrolPath.getNextPatrolPoint())
