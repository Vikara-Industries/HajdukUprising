extends Area2D
class_name Interactable
signal PlayerEnteredInteract
signal PlayerLeftInteract
var player

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	player.interact_pressed.connect(_on_player_interact_pressed)
func _on_player_interact_pressed():
	if isPlayerInGroup(get_overlapping_bodies()):
		
		interact()
func body_entered(_body):
	if isPlayerInGroup(get_overlapping_bodies()):
		emit_signal("PlayerEnteredInteract")
		
func body_exited(_body):
	if not isPlayerInGroup(get_overlapping_bodies()):
		emit_signal("PlayerLeftInteract")
		
func isPlayerInGroup(group):
	for body in group:
		if body.is_in_group("Player"):
			player = body
			return true
func interact():
	pass
