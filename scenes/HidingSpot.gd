extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_player_interact_pressed():
	if isPlayerInGroup(get_overlapping_bodies()):
		
		get_node("../Player").hideInCover()
	
func isPlayerInGroup(group):
	for body in group:
		if body.is_in_group("Player"):
			var player = body
			return true
