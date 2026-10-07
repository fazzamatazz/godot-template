extends Node

@export var cam : Camera3D
@export var _main_scene : MainScene


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		if _main_scene:
			_main_scene.pause_and_open_menu()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.is_action_pressed("move"):
		cam.move_by(event.relative.x, event.relative.y)
	elif event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				cam.zoom_in()
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				cam.zoom_out()
