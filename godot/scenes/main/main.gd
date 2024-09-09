extends Node3D

func _on_button_start_new_game_pressed():
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")
