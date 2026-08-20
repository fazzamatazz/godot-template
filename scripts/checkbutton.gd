extends CheckButton


func _ready() -> void:
	_fix_for_issue_77364()

# https://github.com/godotengine/godot/issues/77364
func _fix_for_issue_77364() -> void:
	focus_entered.connect(add_toggle_highlight)
	focus_exited.connect(remove_toggle_highlight)
	mouse_entered.connect(add_toggle_highlight)
	mouse_exited.connect(remove_toggle_highlight)


func add_toggle_highlight() -> void:
	var focus_color := get_theme_color(&"font_focus_color", &"Button")
	add_theme_color_override(&"font_pressed_color", focus_color) #77364
	add_theme_color_override(&"button_checked_color", focus_color)
	add_theme_color_override(&"button_unchecked_color", focus_color)


func remove_toggle_highlight() -> void:
	remove_theme_color_override(&"font_pressed_color") #77364
	remove_theme_color_override(&"button_checked_color")
	remove_theme_color_override(&"button_unchecked_color")
