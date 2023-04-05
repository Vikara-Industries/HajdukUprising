extends CharacterBody2D


const SPEED = 300.0
const fireSpeed = 2

@onready var sprite := $sprite as AnimatedSprite2D
@onready var weapon := $sprite/Gun as Marker2D
@onready var hitBox := $CollisionShape2D as CollisionShape2D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _animState = "idle"

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
		if(direction<0):
			
			sprite.scale.x = -abs(sprite.scale.x)
			hitBox.position.x = abs(hitBox.position.x)
		else:
			sprite.scale.x = abs(sprite.scale.x)
			hitBox.position.x = -abs(hitBox.position.x)
		_animState = "walk"
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if Input.is_action_pressed("Aim"):
			_animState = "aim"
		else:
			_animState = "idle"
	
	if Input.is_action_pressed("Down") and is_on_floor():
		_animState = "crouch"
		
	if Input.is_action_just_pressed("Shoot"):
		_animState = "shoot"
		weapon.fire()
		
	_handleAnim(_animState)
	move_and_slide()

func _handleAnim(state):
	sprite.animation = state
