extends Area2D

var startingPos
var targetPos
@onready var navigation := $NavigationAgent2D as NavigationAgent2D
# Called when the node enters the scene tree for the first time.
func _ready():
	startingPos = global_position
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	global_position = navigation.get_next_path_position()
	
	for body in get_overlapping_bodies():
		
		if body.is_in_group("Enemy"):
			body.hearNoise(startingPos)
			
	if navigation.distance_to_target()<50:
		destroySelf()
func setTargetPos(pos:Vector2):
	navigation.target_position = pos


func destroySelf():
	queue_free()
