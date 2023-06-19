extends CharacterBody2D


@export var SPEED = 100.0



@export var isInShadow = false
@export var IsInCover = false
@onready var camera := $Camera as Camera2D
@onready var sprite := $sprite as AnimatedSprite2D
@onready var weapon := $sprite/Gun as Node2D
@onready var hitBox := $CollisionShape2D as CollisionShape2D
@onready var gunTimer := $sprite/Gun/Timer as Timer
@onready var interactIndicator := $interactIndicator as Sprite2D
@onready var navigation := $NavigationAgent2D as NavigationAgent2D
@onready var DeathTimer := $DeathTimer as Timer

var aiming = false
var dead = false
var shooting = false
var running = false
var running_mod = 1.5
var running_velocity = SPEED * running_mod
signal interact_pressed
signal _running

func try_interact():
	if(interactIndicator.visible):
		interact_pressed.emit()

func _ready():
	interactIndicator.visible = false
	for interactable in get_tree().get_nodes_in_group("Interactable"):
		interactable.PlayerEnteredInteract.connect(ShowInteract)
		interactable.PlayerLeftInteract.connect(HideInteract)
	
	camera.Up = get_parent().get_node("Up") as Marker2D
	camera.Down = get_parent().get_node("Down") as Marker2D
	camera.Left = get_parent().get_node("Left") as Marker2D
	camera.Right = get_parent().get_node("Right") as Marker2D
	
	
	
	
func _physics_process(_delta):

	if not dead:
		var directionX = Input.get_axis("Left", "Right")
		var directionY = Input.get_axis("Up","Down")
		var running = Input.is_action_pressed("Run")
		
		if directionX or directionY:
			
			velocity = Vector2(directionX, directionY) * SPEED
			if running:
				velocity = Vector2(directionX, directionY) * SPEED *running_mod
				
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)
			if Input.is_action_pressed("Aim"):
				aiming = true
			
		if Input.is_action_just_pressed("Interact"):
			try_interact()
			
		if Input.is_action_just_pressed("Shoot"):
			makeSound()
			if gunTimer.is_stopped():
				weapon.fire(get_global_mouse_position())
				shooting = true
			
		checkNavigation()
		sprite.handleAnimation()
		move_and_slide()

func checkNavigation():
	navigation.target_position = self.position + velocity/5
	if not navigation.is_target_reachable():
		velocity = Vector2(0,0)

func hideInCover():
	IsInCover = true
	self.set_collision_layer_value(1,0)
	self.set_collision_mask_value(1,0)
func comeOutOfCover():
	IsInCover = false
	self.set_collision_layer_value(1,1)
	self.set_collision_mask_value(1,1)

func ShowInteract():
	interactIndicator.visible = true
func HideInteract():
	interactIndicator.visible = false

func makeSound():
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		var sound = load("res://soundEntety.tscn").instantiate()
		add_child(sound)
		sound.setTargetPos(enemy.get_global_position())
		
func die():
	dead = true
	sprite.animation = "die"
	DeathTimer.start()


func _on_death_timer_timeout():
	dead = false
func _unhandled_key_input(event):
	if event.is_action_pressed("Run"):
		emit_signal("_running")

func _on_sprite_animation_finished():
	if shooting:
		shooting = false
