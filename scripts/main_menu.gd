extends Control

@onready var buttons_v_box_container: VBoxContainer = %MenuButtonsVBoxContainer

@export var game: Game


func _ready() -> void:
	_init_signals()


func _init_signals() -> void:
	EventBus.open_main_menu.connect(_open)


func _open() -> void:
	focus_button()
	show()


func focus_button() -> void:
	if buttons_v_box_container:
		for control in buttons_v_box_container.get_children():
			if control is Button or control is HSlider or control is CheckButton:
				control.grab_focus()
				break


func _on_start_game_button_pressed() -> void:
	game.start_main_scene()
	hide()


func _on_exit_game_button_pressed() -> void:
	game.exit_game()


func _on_visibility_changed() -> void:
	if visible:
		focus_button()


func _on_settings_button_pressed() -> void:
	EventBus.emit_signal("open_settings_menu")
	hide()
