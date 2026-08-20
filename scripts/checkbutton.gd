extends CheckButton


func _ready() -> void:
	_fix_for_issue_77364()

# https://github.com/godotengine/godot/issues/77364
func _fix_for_issue_77364() -> void:
	focus_entered.connect(func():
		var focus_color := get_theme_color(&"font_focus_color", &"Button")
		add_theme_color_override(&"font_pressed_color", focus_color) #77364
		add_theme_color_override(&"button_checked_color", focus_color)
		add_theme_color_override(&"button_unchecked_color", focus_color)
	)
	focus_exited.connect(func():
		remove_theme_color_override(&"font_pressed_color") #77364
		remove_theme_color_override(&"button_checked_color")
		remove_theme_color_override(&"button_unchecked_color")
	);
