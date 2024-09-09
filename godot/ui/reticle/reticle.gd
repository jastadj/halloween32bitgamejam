extends TextureRect

func _ready():
	
	update_position()
	
func update_position():
	global_position = get_viewport().size * 0.5
