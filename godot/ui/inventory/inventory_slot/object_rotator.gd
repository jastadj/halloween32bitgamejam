extends Node3D

const rotation_speed:float = 1.0

func _process(_delta):
	
	rotate_y(_delta * rotation_speed)
