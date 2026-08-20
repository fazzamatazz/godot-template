class_name MainScene extends Node3D


@export var game: Game


func stop_game() -> void:
	game.stop_main_scene()
	game.open_main_menu()
