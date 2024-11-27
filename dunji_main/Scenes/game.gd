extends Node2D

func _enter_tree():
	set_multiplayer_authority(1)

@export var player_board: Array
