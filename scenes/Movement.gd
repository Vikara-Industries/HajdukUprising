extends Node


func getVelocity(targetPos):
	return Vector2((targetPos - get_parent().position)*get_parent().Speed)
