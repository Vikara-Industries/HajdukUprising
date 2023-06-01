extends CharacterBody2D

const Speed = 100.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var defaultPath :Path2D
var patrolPointIndex = 0

var dead = false
var distracted = false
var seesPlayer = false
var shooting = false

@onready var sprite := $Sprite2D as AnimatedSprite2D
@onready var Vision := $Sprite2D/Vision as Node2D
@onready var DeathTimer := $DeathTimer as Timer
@onready var sightLines = Vision.get_children()
@onready var navigation :=$NavigationAgent2D as NavigationAgent2D

func _start():
	navigation.set_target_position(global_position)

func _physics_process(delta):
	if not dead:
		
		lookForPlayer()
		if not seesPlayer:
			velocity = (navigation.get_next_path_position()-global_position).normalized()*Speed
		if navigation.distance_to_target() < 9:
			targetReached()
		if not distracted or seesPlayer:
			patrol()
		handleAnimation()
		move_and_slide()
	
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
func lookForPlayer():
	for sightLine in sightLines:
			var collider = sightLine.get_collider()
			if(collider != null and collider.is_in_group("Player") and not get_node('../Player').IsHidden):
				seesPlayer = true
				
				return
	seesPlayer = false
	
	return
	
func setTargetPos(pos:Vector2):
	distracted = true
	navigation.set_target_position(pos)
	
	
func patrol():
	if(defaultPath):
		if(navigation.distance_to_target()<10):
			navigation.set_target_position(getNextPatrolPoint())
		setTargetPos(defaultPath.curve.get_baked_points()[patrolPointIndex]) 
	
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
	velocity = Vector2(0,0)
	distracted = false
	
