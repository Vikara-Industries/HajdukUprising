extends Camera2D
var minZoom = 2.5
@onready var Up := get_parent().Up as Marker2D
@onready var Down := get_parent().Down as Marker2D
@onready var Left := get_parent().Left as Marker2D
@onready var Right := get_parent().Right as Marker2D
func _ready():
	setLimits()
	setZoom()

func setZoom():
	#trial and error shows that 100px distance fits a zoom of ~6.5;
	#when distance doubles,zoom halves
	
	var axis = getShortAxis()
	var axisZoom = 1/(axis/100)*6.5
	var finalZoom = max(minZoom,axisZoom)
	set_zoom(Vector2(finalZoom,finalZoom))
	
func getShortAxis():
	var shorterAxis
	var vertical = Up.position.y - Down.position.y
	var horizontal = Left.position.x - Right.position.x
	if abs(vertical) > abs(horizontal):
		shorterAxis = abs(horizontal)
	else:
		shorterAxis = abs(vertical)
	
	return shorterAxis
	
func setLimits():
	set_limit(SIDE_TOP,Up.position.y)
	set_limit(SIDE_BOTTOM,Down.position.y)
	set_limit(SIDE_LEFT,Left.position.x)
	set_limit(SIDE_RIGHT,Right.position.x)

