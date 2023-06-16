extends Area2D


@onready var player := get_tree().get_nodes_in_group("Player")[0]



func _on_body_entered(body):
	if body == player:
		player.isInShadow = true


func _on_body_exited(body):
	if body == player:
		player.isInShadow = false
