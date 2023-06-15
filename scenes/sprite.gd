extends AnimatedSprite2D


func handleAnimation():
	if get_parent().velocity.x <0:
		scale.x = -abs(scale.x)
	elif get_parent().velocity.x >0:
		scale.x = abs(scale.x)
	if get_parent().shooting:
		animation = "shoot"
	elif get_parent().velocity.length() > 0.01:
		animation = "walk"
	elif get_parent().seesPlayer:
		animation = "aim"
	else:
		animation = "idle"

