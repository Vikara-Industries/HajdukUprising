extends CharacterBody2D

@export var Speed = 1.5
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var defaultPath :Path2D
var patrolPointIndex = 0

var dead = false
var distracted = false
var seesPlayer = false
var shooting = false
var doneAiming = false
@export var player : CharacterBody2D
@onready var sprite := $Sprite2D as AnimatedSprite2D
@onready var Vision := $Vision as Node2D
@onready var DeathTimer := $DeathTimer as Timer
@onready var AimTimer := $AimTimer as Timer
@onready var navigation :=$NavigationAgent2D as NavigationAgent2D
@onready var gun := $Sprite2D/Gun


func _start():
	
	navigation.set_target_position(getNextPatrolPoint())
	if player ==null:
		player = get_tree().get_first_node_in_group("Player")
	
	seesPlayer=false
func _physics_process(delta):
	if not dead:
		
		chooseAction()
		handleAnimation()
		move_and_slide()
	
var hasStartedPatroling = false
func chooseAction():
	if seesPlayer:
		hasStartedPatroling = false
		aimGun()
	elif distracted:
		hasStartedPatroling = false
		investigate()
	else:
		if not hasStartedPatroling:
			if defaultPath:
				setTargetPos(getNextPatrolPoint())
			hasStartedPatroling=true
		patrol()
		lookForPlayer()
		
 
func aimGun():
	velocity = Vector2(0,0)
	if doneAiming:
		gun.fire(player.position)
		AimTimer.stop()
		doneAiming=false
	
func investigate():
	lookForPlayer()	
	moveToTarget()
	if targetReached():
		distracted = false

func patrol():
	if(defaultPath):
		if targetReached():
			setTargetPos(getNextPatrolPoint())
		#setTargetPos(defaultPath.curve.get_baked_points()[patrolPointIndex])
		moveToTarget()
	
func lookForPlayer():
	Vision.look_at(Vector2(position.x+velocity.x,position.y+velocity.y))
	
func _on_timer_timeout():
	doneAiming = true
	

func hearNoise(posNoise):
	setTargetPos(posNoise)
	distracted = true
	
	
func setTargetPos(pos:Vector2):	
	navigation.set_target_position(pos)
	


func moveToTarget():
	velocity = (navigation.get_next_path_position() - position) * Speed
	
func getNextPatrolPoint():
	patrolPointIndex += 1
	if patrolPointIndex >= defaultPath.curve.get_baked_points().size():
		patrolPointIndex = 0
	return defaultPath.curve.get_baked_points()[patrolPointIndex]
	
func die():
	dead = true
	sprite.animation = "die"
	DeathTimer.start()


func _on_death_timer_timeout():
	self.queue_free()


func targetReached():
	if navigation.distance_to_target() < 10:
		return true
	else:
		return false

func handleAnimation():
	if velocity.x <0:
		sprite.scale.x = -abs(sprite.scale.x)
	else:
		sprite.scale.x = abs(sprite.scale.x)
	if shooting:
		sprite.animation = "shoot"
	elif velocity.length() > 0.01:
		sprite.animation = "walk"
	elif seesPlayer:
		sprite.animation = "aim"
	else:
		sprite.animation = "idle"


var hasInitiated = false
func _on_vision_cone_2d_body_entered():
	if hasInitiated:
		seesPlayer = true
		AimTimer.start()
	hasInitiated= true
	


func _on_vision_cone_2d_body_exited():
	seesPlayer = false
	AimTimer.stop()
	
