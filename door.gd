extends Interactable
class_name Door

@export var texture :Texture2D 
@export var targetDoor :Door
@export var locked = false

@onready var Sprite := $Portal as Sprite2D



func _ready():
	Sprite.texture = texture
	player = get_tree().get_first_node_in_group("Player")
	player.interact_pressed.connect(_on_player_interact_pressed)
	
func _on_body_entered(body):
	if isPlayerInGroup(get_overlapping_bodies()):
		emit_signal("PlayerEnteredInteract")


func _on_body_exited(body):
	body_exited(body)
	
func interact():
	if not locked:
		player.position = targetDoor.position
		player.camera.Left = targetDoor.get_parent().find_child("Left")
		player.camera.Right = targetDoor.get_parent().find_child("Right")
		player.camera.Up = targetDoor.get_parent().find_child("Top")
		player.camera.Down = targetDoor.get_parent().find_child("Bottom")
		
		
		player.camera.setLimits()
		player.camera.setZoom()
		player.camera.align()
		
	else:
		print_debug("it's locked")
