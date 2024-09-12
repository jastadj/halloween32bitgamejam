class_name MessageHistory
extends Control

func add_message(msg:String):
	var new_msg:Message = Message.new(msg)
	$VFlowContainer.add_child(new_msg)
