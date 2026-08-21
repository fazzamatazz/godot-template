extends Control

@onready var buttons_grid_container: GridContainer = %SettingsButtonsGridContainer
@onready var fullscreen_toggle: CheckButton = %FullscreenCheckButton
@onready var vsync_toggle: CheckButton = %VsyncCheckButton
@onready var invert_mouse_check_button: CheckButton = %InvertMouseCheckButton
@onready var invert_gamepad_check_button: CheckButton = %InvertGamepadCheckButton
@onready var target_fps_slider: HSlider = %TargetFPSSlider
@onready var master_volume_slider: HSlider = %MasterVolumeSlider
@onready var music_volume_slider: HSlider = %MusicVolumeSlider
@onready var sound_volume_slider: HSlider = %SoundVolumeSlider
@onready var mouse_sensitivity_slider: HSlider = %MouseSensitivitySlider
@onready var gamepad_sensitivity_slider: HSlider = %GamepadSensitivitySlider

@onready var audio_bus_master := AudioServer.get_bus_index("Master")
@onready var audio_bus_music := AudioServer.get_bus_index("Music")
@onready var audio_bus_sound := AudioServer.get_bus_index("Sound")

var user_prefs : UserPreferences


func _ready() -> void:
	_init_user_preferences()
	_init_signals()


func _init_signals() -> void:
	EventBus.open_settings_menu.connect(_open)


func _open() -> void:
	focus_button()
	show()


func is_in_game() -> bool:
	return get_tree().paused


func _init_user_preferences() -> void:
	user_prefs = UserPreferences.load_or_create()
	_on_master_volume_slider_value_changed(user_prefs.master_volume)
	master_volume_slider.value = user_prefs.master_volume
	_on_music_volume_slider_value_changed(user_prefs.music_volume)
	music_volume_slider.value = user_prefs.music_volume
	_on_sound_volume_slider_value_changed(user_prefs.sound_volume)
	sound_volume_slider.value = user_prefs.sound_volume
	vsync_toggle.button_pressed = user_prefs.vsync_enabled
	_on_vsync_check_button_toggled(user_prefs.vsync_enabled)
	fullscreen_toggle.button_pressed = user_prefs.fullscreen_enabled
	_on_fullscreen_check_button_toggled(user_prefs.fullscreen_enabled)
	invert_mouse_check_button.button_pressed = user_prefs.invert_mouse
	invert_gamepad_check_button.button_pressed = user_prefs.invert_gamepad
	_on_mouse_sensitivity_slider_value_changed(user_prefs.mouse_sensitivity)
	mouse_sensitivity_slider.value = user_prefs.mouse_sensitivity
	_on_gamepad_sensitivity_slider_value_changed(user_prefs.gamepad_sensitivity)
	gamepad_sensitivity_slider.value = user_prefs.gamepad_sensitivity


func focus_button() -> void:
	if buttons_grid_container:
		var control := buttons_grid_container.get_child(1)
		if control is Button or control is HSlider or control is CheckButton:
			control.grab_focus()


func _on_visibility_changed() -> void:
	if visible:
		focus_button()


func _on_back_button_pressed() -> void:
	if is_in_game():
		EventBus.emit_signal("open_pause_menu")
	else:
		EventBus.emit_signal("open_main_menu")
	hide()


func _on_invert_mouse_check_button_toggled(toggled_on: bool) -> void:
	EventBus.emit_signal("settings_invert_mouse", toggled_on)
	user_prefs.invert_mouse = toggled_on
	user_prefs.save()


func _on_invert_gamepad_check_button_toggled(toggled_on: bool) -> void:
	EventBus.emit_signal("settings_invert_gamepad", toggled_on)
	user_prefs.invert_gamepad = toggled_on
	user_prefs.save()


func _on_fullscreen_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	user_prefs.fullscreen_enabled = toggled_on
	user_prefs.save()


func _on_vsync_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		target_fps_slider.editable = false
		target_fps_slider.setLabelValue(0.0)
	else:
		target_fps_slider.editable = true
		target_fps_slider.setLabelValue(user_prefs.target_fps)
		target_fps_slider.value = user_prefs.target_fps
	user_prefs.vsync_enabled = toggled_on
	user_prefs.save()
	if is_in_game():
		if user_prefs.vsync_enabled:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
			Engine.set_max_fps(0)
		else:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
			Engine.set_max_fps(int(user_prefs.target_fps))


func _on_target_fps_slider_value_changed(value: float) -> void:
	target_fps_slider.setLabelValue(value)
	user_prefs.target_fps = value
	user_prefs.save()
	if is_in_game() and !user_prefs.vsync_enabled:
		Engine.set_max_fps(int(user_prefs.target_fps))


func _on_master_volume_slider_value_changed(value: float) -> void:
	master_volume_slider.setLabelValue(value)
	AudioServer.set_bus_volume_db(audio_bus_master, linear_to_db(value * 0.01))
	user_prefs.master_volume = value
	user_prefs.save()


func _on_music_volume_slider_value_changed(value: float) -> void:
	music_volume_slider.setLabelValue(value)
	AudioServer.set_bus_volume_db(audio_bus_music, linear_to_db(value * 0.01))
	user_prefs.music_volume = value
	user_prefs.save()


func _on_sound_volume_slider_value_changed(value: float) -> void:
	sound_volume_slider.setLabelValue(value)
	AudioServer.set_bus_volume_db(audio_bus_sound, linear_to_db(value * 0.01))
	user_prefs.sound_volume = value
	user_prefs.save()


func _on_mouse_sensitivity_slider_value_changed(value: float) -> void:
	mouse_sensitivity_slider.setLabelValue(value)
	EventBus.emit_signal("settings_change_mouse_sensitivity", value)
	user_prefs.mouse_sensitivity = value
	user_prefs.save()


func _on_gamepad_sensitivity_slider_value_changed(value: float) -> void:
	gamepad_sensitivity_slider.setLabelValue(value)
	EventBus.emit_signal("settings_change_gamepad_sensitivity", value)
	user_prefs.gamepad_sensitivity = value
	user_prefs.save()
