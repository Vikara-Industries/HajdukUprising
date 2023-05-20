extends Area2D
class_name Interactable
signal PlayerEnteredInteract
signal PlayerLeftInteract

func _on_player_interact_pressed():
	if isPlayerInGroup(get_overlapping_bodies()):
		
		interact()
func body_entered():
	if isPlayerInGroup(get_overlapping_bodies()):
		emit_signal("PlayerEnteredInteract")
		
func body_exited():
	if not isPlayerInGroup(get_overlapping_bodies()):
		emit_signal("PlayerLeftInteract")
		
func isPlayerInGroup(group):
	for body in group:
		if body.is_in_group("Player"):
			var player = body
			return true
func interact():
	pass
