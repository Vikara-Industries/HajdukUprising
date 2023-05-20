extends Node2D
signal TimerDone
@onready var ray := $fireLine as RayCast2D
@export var targetGroup :String
var target :Vector2

func fire():
	ray.position = position
	ray.target_position = to_local(target)
	
	var hit = ray.get_collider()
	
	if(hit != null):
		if(hit.is_in_group(targetGroup)):
			ray.get_collider().die()
			


func _on_timer_timeout():
	TimerDone.emit()
