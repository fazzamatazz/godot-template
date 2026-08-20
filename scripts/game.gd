class_name Game extends Node

@onready var _loading_screen: Control = %LoadingScreen
@onready var _loading_sprite: Sprite2D = %Sprite2D

var _main_scene: MainScene
var _is_loading: bool = true


func _ready() -> void:
	open_main_menu()
	_hide_loading_screen()


func open_main_menu() -> void:
	EventBus.emit_signal("open_main_menu")


func _process(delta: float) -> void:
	if _is_loading:
		_loading_sprite.rotation += delta * 4.0


func exit_game() -> void:
	get_tree().quit()


func _show_loading_screen() -> void:
	_loading_screen.show()
	_is_loading = true


func _hide_loading_screen() -> void:
	_loading_screen.hide()
	_is_loading = false
	_loading_sprite.rotation = 0.0


func start_main_scene() -> void:
	_main_scene = preload("uid://drugaqdqqegi8").instantiate()
	_main_scene.game = self
	add_child(_main_scene)
	move_child(_main_scene, 0)
	#_hide_loading_screen()


func stop_main_scene() -> void:
	if _main_scene:
		_main_scene.queue_free()
		remove_child(_main_scene)
