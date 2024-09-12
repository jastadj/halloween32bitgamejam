extends Node3D

@onready var player:Player = $objects/player

func _ready():
	System.game = self
