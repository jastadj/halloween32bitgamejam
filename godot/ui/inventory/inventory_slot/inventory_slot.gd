extends SubViewportContainer

var _object = null

func set_object(obj:RigidBody3D) -> bool:
	
	# do some error checking, dont add null objects and dont allow changing
	# an object in a slot if one is already assigned
	if obj == null:
		push_error("error adding object to inventory slot, obj is null!")
		return false
	elif _object != null:
		push_error("cannot add object ",obj.name, " to inventory slot, already has object ", _object.name)
		return false
	
	# set the object reference
	_object = obj
	
	# reset any object transforms
	_object.global_position = Vector3()
	_object.rotation = Vector3()
	
	# add object to rotator node
	$SubViewport/world/object_anchor/object_rotator.add_child(_object)
	
	return true
