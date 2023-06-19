extends Node2D


@onready var distracted := $distracted as AudioStreamPlayer2D
@onready var spotted := $spotted as AudioStreamPlayer2D


func _on_ai__distracted():
	distracted.play()


func _on_ai__spotted_player():
	spotted.play()
