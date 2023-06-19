extends Node2D


@onready var running := $running as AudioStreamPlayer2D



func _on_player__running():
	running.play()


func _on_running_finished():
	if get_parent().velocity.length() >= 150:
		running.play()
