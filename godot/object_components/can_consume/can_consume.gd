class_name ComponentConsume
extends Node

@export var health_mod:float = 0.0
@export var consume_verb:String = "eat"

func consume():
	print("You ", consume_verb, " the ", get_parent().get_node("object_info").object_name, ".")
