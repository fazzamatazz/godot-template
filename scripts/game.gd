class_name Game extends Node

@onready var _loading_screen: Control = %LoadingScreen
@onready var _loading_sprite: Sprite2D = %Sprite2D
@onready var _background: ColorRect = %BgColorRect

var _main_scene: MainScene
var _is_loading: bool = true

var user_prefs : UserPreferences


func _ready() -> void:
	_init_signals()
	EventBus.emit_signal("open_main_menu")
	_hide_loading_screen()


func _init_signals() -> void:
	EventBus.pause_game.connect(pause_game)
	EventBus.resume_game.connect(resume_game)


func pause_game() -> void:
	get_tree().paused = true


func resume_game() -> void:
	get_tree().paused = false


# sets the FPS and vsync settings for game versus menu
func set_game_mode(enabled: bool) -> void:
	# this needs to be reloaded in case settings were changed
	user_prefs = UserPreferences.load_or_create()
	if enabled:
		if user_prefs.vsync_enabled:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
			Engine.set_max_fps(0)
		else:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
			Engine.set_max_fps(int(user_prefs.target_fps))
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		Engine.set_max_fps(0)


func _process(delta: float) -> void:
	if _is_loading:
		_loading_sprite.rotation += delta * 4.0


func _input(event: InputEvent) -> void:
	if event is InputEventMouse or event is InputEventMouseButton or event is InputEventMouseMotion:
		if !_main_scene or get_tree().paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


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
	set_game_mode(true)
	_background.hide()
	#_hide_loading_screen()


func stop_main_scene() -> void:
	if _main_scene:
		_main_scene.queue_free()
		remove_child(_main_scene)
		set_game_mode(false)
		_background.show()
		get_tree().paused = false
