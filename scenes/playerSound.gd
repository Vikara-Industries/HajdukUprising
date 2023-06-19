extends Node2D


@onready var running := $running as AudioStreamPlayer2D



func _on_player_started_running():
	running.play()
	get_parent().makeSound()


func _on_player_stopped_running():
	running.stop()


