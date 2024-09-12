class_name ComponentConsume
extends Node

@export var health_mod:float = 0.0
@export var consume_verb:String = "eat"

var object = null

func _ready():
	await get_parent().ready
	object = get_parent()

func consume():
	System.message(str("You ", consume_verb, " the ", object.get_node("object_info").object_name, "."))
	get_parent().get_parent().remove_child(get_parent())
	
