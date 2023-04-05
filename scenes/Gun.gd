extends Marker2D

@onready var ray := $fireLine as RayCast2D

func fire():
	
	ray.target_position = get_global_mouse_position()
	
	var hit = ray.get_collider()
	print_debug(ray.global_position,ray.target_position)
	if(hit != null):
		print_debug(ray.get_collider())
		if(hit.is_in_group("Enemy")):
			ray.get_collider().die()
