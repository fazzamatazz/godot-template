class_name Game extends Node

@onready var _loading_screen: Control = %LoadingScreen
@onready var _loading_sprite: Sprite2D = %Sprite2D

@export var _main_scene: PackedScene

var _is_loading: bool = true
var _main: MainScene


func _ready() -> void:
	start_main_scene()


func _process(delta: float) -> void:
	if _is_loading:
		_loading_sprite.rotation += delta * 4.0


func _show_loading_screen() -> void:
	_loading_screen.show()
	_is_loading = true


func _hide_loading_screen() -> void:
	_loading_screen.hide()
	_is_loading = false
	_loading_sprite.rotation = 0.0


func start_main_scene() -> void:
	_main = _main_scene.instantiate()
	add_child(_main)
	move_child(_main, 0)
	_hide_loading_screen()


func stop_main_scene() -> void:
	if _main:
		_main.queue_free()
		remove_child(_main)
