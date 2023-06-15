extends Node
class_name PatrolPath

var pathPoints :PackedVector2Array
var pathIndex = 0
func _init(path :PackedVector2Array):
	pathPoints = path
# Called every frame. 'delta' is the elapsed time since the previous frame.
func getNextPatrolPoint():
	pathIndex += 1
	if pathIndex >= pathPoints.size():
		pathIndex = 0
	return pathPoints[pathIndex]
