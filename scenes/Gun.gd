extends Node2D
signal TimerDone
var hit
@onready var ray := $fireLine as RayCast2D
@onready var endSpark := $particle2 as CPUParticles2D
@onready var startSpark := $particle1 as CPUParticles2D
@onready var timer := $Timer as Timer
@export var targetGroup :String


func fire(target :Vector2):

	ray.enabled = true
	ray.position = position
	ray.target_position = to_local(target)

	ray.force_raycast_update()
	hit = ray.get_collider()
	
	
	setParticles()
	
	if(hit != null):
		if(hit.has_method("die")):
			hit.die()
			
func _on_timer_timeout():
	disableSparks()
	ray.enabled = false
	
func setParticles():
	timer.start()
	enableSparks()
	if hit:
		endSpark.global_position = ray.get_collision_point()
	else:
		endSpark.position = ray.target_position
		
func enableSparks():
	startSpark.emitting = true
	endSpark.emitting = true
func disableSparks():
	startSpark.emitting = false
	endSpark.emitting = false
