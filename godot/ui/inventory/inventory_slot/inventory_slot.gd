extends Control

const inventory_size:int = 128
const inventory_hover_size:int = 142

@onready var subviewport_container = $SubViewportContainer
@onready var subviewport = $SubViewportContainer/SubViewport

var _object:RigidBody3D = null
var _draw_tooltip:bool = false

func _ready():
	
	# set control size to maximum size (hover size)
	custom_minimum_size = Vector2(inventory_hover_size, inventory_hover_size)
	size = custom_minimum_size
	
	resize_not_hovered()

func _gui_input(event):
	
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_RIGHT:
				var context = preload("res://ui/inventory/item_context/item_context.tscn").instantiate()
				context._object = _object
				add_child(context)
				context.set_dialog_position(get_global_mouse_position())

func _process(_delta):
	
	if _draw_tooltip:
		$tooltip_offset.global_position = get_global_mouse_position()

func resize_not_hovered():
	# set subviewport to normal size (not hovered)
	var vp_offset = float(inventory_hover_size - inventory_size) / 2.0
	subviewport_container.size = Vector2(inventory_size, inventory_size)
	subviewport_container.position = Vector2(vp_offset, vp_offset)
	subviewport.size = subviewport_container.size
	
func resize_hovered():
	subviewport_container.size = size
	subviewport_container.position = Vector2()
	subviewport.size = size

func set_object(obj:RigidBody3D) -> bool:
	
	# do some error checking, dont add null objects and dont allow changing
	# an object in a slot if one is already assigned
	if obj == null:
		push_error("error adding object to inventory slot, obj is null!")
		return false
	elif _object != null:
		push_error("cannot add object ",obj.name, " to inventory slot, already has object ", _object.name)
		return false
	elif obj.get_node_or_null("can_interact") == null:
		push_error("cannot add object ", obj.name, " to inventory slot, no interaction node found!")
		return false
	
	# set the object reference
	_object = obj
	
	# add object to rotator node
	$SubViewportContainer/SubViewport/world/object_anchor/object_rotator.call_deferred("add_child", _object)
	
	# set tooltip text
	$tooltip_offset/tooltip.text = _object.get_node("object_info").object_name
	
	return true

func _on_mouse_entered():
	_draw_tooltip = true
	$tooltip_offset.visible = true
	resize_hovered()
	
func _on_mouse_exited():
	_draw_tooltip = false
	$tooltip_offset.visible = false
	resize_not_hovered()

func _on_object_rotator_child_exiting_tree(_node):
	queue_free()
