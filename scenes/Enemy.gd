extends CharacterBody2D

@export var Speed = 1.5
@export var defaultPath2D :Path2D

var currentPath :PackedVector2Array
var patrolPointIndex = 0

var dead = false
var distracted = false
var seesPlayer = false
var shooting = false
var doneAiming = false
var action
var defaultPatrolPath 

@onready var player := get_tree().get_nodes_in_group("Player")[0]
@onready var sprite := $Sprite2D as AnimatedSprite2D
@onready var vision := $Vision as Node2D
@onready var movement := $Movement
@onready var DeathTimer := $DeathTimer as Timer
@onready var navigation :=$NavigationAgent2D as NavigationAgent2D
@onready var gun := $Sprite2D/Gun
@onready var Ai := $AI as AI

func _ready():
	if defaultPath2D:
		defaultPatrolPath = PatrolPath.new(defaultPath2D.curve.get_baked_points())

func _physics_process(_delta):
	if not dead:
		action = Ai.chooseAction()
		sprite.handleAnimation()
		doAction()
		move_and_slide()
		
func doAction():
	if action == "shoot":
		gun.fire(player.position)
	else:
		setVelocity()
func setVelocity():
	if action == "idle" or "aim":
		velocity = Vector2(0,0)
	if action == "moveOnPath":
		velocity = movement.getVelocity(navigation.get_next_path_position())
	if velocity.length() > 0.01:
		vision.look_at(Vector2(position.x+velocity.x, position.y+velocity.y))

func hearNoise(posNoise):
	Ai.hearNoise(posNoise)

func setTarget(posTarget):
	navigation.target_position = posTarget


func die():
	dead = true
	sprite.animation = "die"
	DeathTimer.start()

func _on_death_timer_timeout():
	self.queue_free()
