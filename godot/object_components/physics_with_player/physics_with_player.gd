extends Node

var _rigid_body:RigidBody3D = null

func _ready():
	await get_parent().ready
	
	if get_parent() is RigidBody3D:
		_rigid_body = get_parent()
		_rigid_body.collision_layer = 0x4
		_rigid_body.collision_mask = 0x7

		
