extends CharacterBody2D


@export var SPEED = 300.0
@export var Left:Marker2D
@export var Right:Marker2D
@export var Up:Marker2D
@export var Down:Marker2D
@export var IsHidden = false

@onready var camera := $Camera as Camera2D
@onready var sprite := $sprite as AnimatedSprite2D
@onready var weapon := $sprite/Gun as Node2D
@onready var hitBox := $CollisionShape2D as CollisionShape2D
@onready var gunTimer := $sprite/Gun/Timer as Timer
@onready var interactIndicator := $interactIndicator as Sprite2D
@onready var navigation := $NavigationAgent2D as NavigationAgent2D

var _animState = "idle"


signal interact_pressed


func try_interact():
	if(interactIndicator.visible):
		interact_pressed.emit()

func _ready():
	interactIndicator.visible = false
	for interactable in get_tree().get_nodes_in_group("Interactable"):
		interactable.PlayerEnteredInteract.connect(ShowInteract)
		interactable.PlayerLeftInteract.connect(HideInteract)
	
	
	
func _physics_process(_delta):


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var directionX = Input.get_axis("Left", "Right")
	var directionY = Input.get_axis("Up","Down")
	if directionX or directionY:
		
		velocity.y = directionY * SPEED
		velocity.x = directionX * SPEED
		if(directionX<0):
			
			sprite.scale.x = -abs(sprite.scale.x)
			hitBox.position.x = abs(hitBox.position.x)
		else:
			sprite.scale.x = abs(sprite.scale.x)
			hitBox.position.x = -abs(hitBox.position.x)
		_animState = "walk"
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		if Input.is_action_pressed("Aim"):
			_animState = "aim"
		else:
			_animState = "idle"
	if Input.is_action_just_pressed("Interact"):
		try_interact()
		
	if Input.is_action_just_pressed("Shoot"):
		makeSound()
		if gunTimer.is_stopped():
			weapon.fire()
			gunTimer.start()
	
	if IsHidden:
		_animState = "hide"
		
	checkNavigation()
	_handleAnim(_animState)
	move_and_slide()

func checkNavigation():
	navigation.target_position = self.position + velocity/5
	if not navigation.is_target_reachable():
		velocity = Vector2(0,0)
func _handleAnim(state):
	if gunTimer.is_stopped():
		sprite.animation = state
	else:
		sprite.animation = "shoot"
	
func hideInCover():
	IsHidden = true
	self.set_collision_layer_value(1,0)
	self.set_collision_mask_value(1,0)
func comeOutOfCover():
	IsHidden = false
	self.set_collision_layer_value(1,1)
	self.set_collision_mask_value(1,1)
	
func _on_gun_timer_done():
	sprite.sprite_frames.set("shoot",0)

func ShowInteract():
	interactIndicator.visible = true
func HideInteract():
	interactIndicator.visible = false

func makeSound():
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		var sound = load("res://soundEntety.tscn").instantiate()
		add_child(sound)
		sound.setTargetPos(enemy.get_global_position())
		
