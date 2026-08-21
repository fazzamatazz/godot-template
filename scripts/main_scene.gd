class_name MainScene extends Node3D


@export var game: Game


func pause_and_open_menu() -> void:
	EventBus.emit_signal('pause_game')
	EventBus.emit_signal('open_pause_menu')
