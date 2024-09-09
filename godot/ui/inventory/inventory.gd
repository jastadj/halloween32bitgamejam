extends Control

@onready var grid:GridContainer = $PanelContainer/GridContainer

func _ready():
	pass

func _clear_grid():
	
	for child in grid.get_children():
		grid.remove_child(child)
		child.queue_free()

func _on_visibility_changed():
	pass

func add_object(object:RigidBody3D) -> bool:
	if object == null:
		return false
	
	object.get_parent().remove_child(object)
	
	var new_slot = preload("res://ui/inventory/inventory_slot/inventory_slot.tscn").instantiate()
	new_slot.set_object(object)
	grid.add_child(new_slot)
	
	return true
