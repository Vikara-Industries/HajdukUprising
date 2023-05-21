extends Camera2D


@onready var Up := get_parent().Up as Marker2D
@onready var Down := get_parent().Down as Marker2D
@onready var Left := get_parent().Left as Marker2D
@onready var Right := get_parent().Right as Marker2D
func _ready():
	setLimits()
	setZoom()

func setZoom():
	#trial and error shows that 100px distance fits a zoom of ~6
	var axis = getShortAxis()
	set_zoom(Vector2((1/(axis/100))*6,(1/(axis/100))*6))
	print_debug(axis)
func getShortAxis():
	var vertical = Up.position.y - Down.position.y
	var horizontal = Left.position.x - Right.position.x
	if abs(vertical) > abs(horizontal):
		return abs(horizontal)
	return abs(vertical)
func setLimits():
	set_limit(SIDE_TOP,Up.position.y)
	set_limit(SIDE_BOTTOM,Down.position.y)
	set_limit(SIDE_LEFT,Left.position.x)
	set_limit(SIDE_RIGHT,Right.position.x)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

