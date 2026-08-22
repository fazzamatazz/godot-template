extends Control

@onready var buttons_grid_container: GridContainer = %RebindKeysGridContainer

var user_prefs : UserPreferences


func _ready() -> void:
	_init_user_preferences()
	_init_signals()


func _init_signals() -> void:
	EventBus.open_rebind_keys_menu.connect(_open)


func _open() -> void:
	focus_button()
	show()


func _init_user_preferences() -> void:
	user_prefs = UserPreferences.load_or_create()


func focus_button() -> void:
	if buttons_grid_container:
		var control := buttons_grid_container.get_child(1)
		if control is Button or control is HSlider or control is CheckButton:
			control.grab_focus()


func _on_visibility_changed() -> void:
	if visible:
		focus_button()


func _on_back_button_pressed() -> void:
	EventBus.emit_signal("open_settings_menu")
	hide()
