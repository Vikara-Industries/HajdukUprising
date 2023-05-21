extends Interactable

@export var texture :Texture2D 
@onready var Sprite := $Portal as Sprite2D

func _ready():
	Sprite.texture = texture
	
func _on_body_entered(body):
	if isPlayerInGroup(get_overlapping_bodies()):
		emit_signal("PlayerEnteredInteract")


func _on_body_exited(body):
	body_exited()
	
func interact():
	print_debug("It's locked")

