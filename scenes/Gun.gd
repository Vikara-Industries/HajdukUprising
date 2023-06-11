extends Node2D
signal TimerDone
@onready var ray := $fireLine as RayCast2D
@export var targetGroup :String

func fire(target :Vector2):
	ray.position = position
	ray.target_position = to_local(target)
	
	var hit = ray.get_collider()
	
	if(hit != null):
		if(hit.has_method("die")):
			hit.die()
			


func _on_timer_timeout():
	TimerDone.emit()
