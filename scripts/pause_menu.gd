extends Control

@onready var buttons_v_box_container: VBoxContainer = %PauseButtonsVBoxContainer

@export var game: Game


func _ready() -> void:
	_init_signals()


func _init_signals() -> void:
	EventBus.open_pause_menu.connect(_open)


func _open() -> void:
	focus_button()
	show()


func focus_button() -> void:
	if buttons_v_box_container:
		for control in buttons_v_box_container.get_children():
			if control is Button or control is HSlider or control is CheckButton:
				control.grab_focus()
				break


func _on_visibility_changed() -> void:
	if visible:
		focus_button()


func _on_quit_game_button_pressed() -> void:
	game.stop_main_scene()
	EventBus.emit_signal("open_main_menu")
	hide()


func _on_resume_game_button_pressed() -> void:
	EventBus.emit_signal('resume_game')
	hide()


func _on_in_game_settings_button_pressed() -> void:
	EventBus.emit_signal("open_settings_menu")
	hide()
