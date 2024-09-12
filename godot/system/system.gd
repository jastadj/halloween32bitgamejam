extends Node

var game = null

func message(msg:String):
	game.player.message_history.add_message(msg)
