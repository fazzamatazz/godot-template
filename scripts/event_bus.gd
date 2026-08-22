extends Node

@warning_ignore_start("unused_signal")

signal settings_invert_mouse(toggled_on: bool)
signal settings_invert_gamepad(toggled_on: bool)
signal settings_change_mouse_sensitivity(value: float)
signal settings_change_gamepad_sensitivity(value: float)
signal open_main_menu()
signal open_settings_menu()
signal open_pause_menu()
signal pause_game()
signal resume_game()

@warning_ignore_restore("unused_signal")
