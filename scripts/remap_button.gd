class_name RemapButton extends Button

@export var action : String
@export var is_gamepad: bool = false


func _init() -> void:
	toggle_mode = true
	theme_type_variation = "RemapButton"


func _ready() -> void:
	set_process_unhandled_input(false)
	update_key_text()


func _toggled(_pressed: bool) -> void:
	set_process_unhandled_input(_pressed)
	if _pressed:
		text = ".."
		#release_focus()
	else:
		update_key_text()
		grab_focus()


func _unhandled_input(event: InputEvent) -> void:
	if !is_gamepad:
		if event is InputEventKey or event is InputEventMouseButton:
			if event.pressed:
				for existing_event in InputMap.action_get_events(action):
					if existing_event is InputEventKey or existing_event is InputEventMouseButton:
						InputMap.action_erase_event(action, existing_event)
				InputMap.action_add_event(action, event)
				button_pressed = false
		else:
			button_pressed = false
	else:
		if event is InputEventJoypadButton or event is InputEventJoypadMotion:
			if event.pressed:
				for existing_event in InputMap.action_get_events(action):
					if existing_event is InputEventJoypadButton or existing_event is InputEventJoypadMotion:
						InputMap.action_erase_event(action, existing_event)
				InputMap.action_add_event(action, event)
				button_pressed = false
		else:
			button_pressed = false


func update_key_text() -> void:
	for existing_event in InputMap.action_get_events(action):
		if !is_gamepad:
			if existing_event is InputEventKey or existing_event is InputEventMouseButton:
				text = "%s" % existing_event.as_text()
				print(existing_event.as_text())
				break
		else:
			if existing_event is InputEventJoypadButton or existing_event is InputEventJoypadMotion:
				text = "%s" % existing_event.as_text()
				print(existing_event.as_text())
				break
