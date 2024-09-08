extends RayCast3D

var looking_at = null

func _process(_delta):
	
	var collider:CollisionObject3D = get_collider()
	
	# if looking at something different
	if collider != looking_at:
		
		# if previous was an object
		if looking_at != null and looking_at.get_node_or_null("can_interact") != null:
			looking_at.get_node("can_interact").targeted = false
		
		if collider != null and collider.get_node_or_null("can_interact") != null:
			collider.get_node("can_interact").targeted = true
		
		looking_at = collider
