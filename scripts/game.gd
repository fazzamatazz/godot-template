class_name Game extends Node

@export var main_scene: PackedScene

var main: MainScene


func _ready() -> void:
	start_main_scene()


func start_main_scene() -> void:
	main = main_scene.instantiate()
	add_child(main)
	move_child(main, 0)


func stop_main_scene() -> void:
	if main:
		main.queue_free()
		remove_child(main)
