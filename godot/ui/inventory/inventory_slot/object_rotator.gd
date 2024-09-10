extends Node3D

const rotation_speed:float = 1.0

signal object_removed

func _process(_delta):
	
	rotate_y(_delta * rotation_speed)

func _on_child_entered_tree(node:RigidBody3D):
	
	# stop collision
	node.freeze = true
	
	# reset transforms
	node.position = Vector3()
	node.rotation = Vector3()
