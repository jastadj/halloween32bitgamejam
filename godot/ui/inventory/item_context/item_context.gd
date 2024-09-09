extends Control

var _object = null
var _interact_node = null

var _actions = []
var _consume_node = null

func _ready():
	
	_interact_node = _object.get_node_or_null("can_interact")
	
	var consume_node = _object.get_node_or_null("can_consume")
	if consume_node != null:
		$PopupMenu.add_item(consume_node.consume_verb.capitalize())
		_consume_node = consume_node
		_actions.append(_consume_node)
	
	
	$PopupMenu.show()

func _on_popup_menu_popup_hide():
	get_parent().remove_child(self)
	queue_free()

func set_dialog_position(pos):
	$PopupMenu.position = pos


func _on_popup_menu_index_pressed(index):
	
	if _actions[index] == _consume_node:
		print("you ", _consume_node.consume_verb, " the ", _interact_node.object_name, ".")
