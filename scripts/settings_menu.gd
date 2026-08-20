class_name SettingsMenu extends Control

@onready var buttons_v_box_container: VBoxContainer = %SettingsButtonsVBoxContainer
@onready var fullscreen_toggle: CheckButton = %FullscreenCheckButton
@onready var vsync_toggle: CheckButton = %VsyncCheckButton
@onready var invert_mouse_check_button: CheckButton = %InvertMouseCheckButton
@onready var invert_gamepad_check_button: CheckButton = %InvertGamepadCheckButton

var user_prefs : UserPreferences


func _ready() -> void:
	_init_user_preferences()
	_init_signals()


func _init_signals() -> void:
	EventBus.open_settings_menu.connect(_open)


func _open() -> void:
	focus_button()
	show()


func _init_user_preferences() -> void:
	user_prefs = UserPreferences.load_or_create()
	vsync_toggle.button_pressed = user_prefs.vsync_enabled
	_on_vsync_check_button_toggled(user_prefs.vsync_enabled)
	fullscreen_toggle.button_pressed = user_prefs.fullscreen_enabled
	_on_vsync_check_button_toggled(user_prefs.fullscreen_enabled)
	invert_mouse_check_button.button_pressed = user_prefs.invert_mouse
	invert_gamepad_check_button.button_pressed = user_prefs.invert_gamepad


func focus_button() -> void:
	if buttons_v_box_container:
		var button : Button = buttons_v_box_container.get_child(0)
		if button is Button:
			button.grab_focus()


func _on_visibility_changed() -> void:
	if visible:
		focus_button()


func _on_back_button_pressed() -> void:
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
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	user_prefs.vsync_enabled = toggled_on
	user_prefs.save()
