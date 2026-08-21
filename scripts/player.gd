class_name Player extends CharacterBody3D

const MAX_ANGLE_LOOK_UP := deg_to_rad(70)
const MAX_ANGLE_LOOK_DOWN := deg_to_rad(-70)
const STEP_HEIGHT_THRESHOLD := 0.05
const MAX_FALL_SPEED := 20.0

@export var _walk_speed := 3.0
@export var _run_speed := 6.0
@export var _jump_speed := 4.0
@export var _max_step_height := 0.4
# in metres per second. This is implemented as a delay before the next step can be taken, rather than a velocity
@export var _step_speed := 1.5
@export var _invert_mouse := false
@export var _mouse_sensitivity_x := 0.004
@export var _mouse_sensitivity_y := 0.004
@export var _invert_gamepad := false
@export var _gamepad_sensitivity_x := 0.05
@export var _gamepad_sensitivity_y := 0.05
@export var _spotlight : SpotLight3D
@export var _main_scene : MainScene

@onready var _head := %Head
@onready var _camera_pivot := %CameraPivot
@onready var _camera := %Camera3D
@onready var _step_handler := %StepHandler
@onready var _step_raycast := %StepRayCast3D

var user_prefs : UserPreferences

var _input_dir : Vector2
var _step_timer := 0.0
var _direction : Vector3
var _is_running := false


func _ready() -> void:
	_init_user_preferences()	
	_init_stephandler()
	_init_signals()
	_capture_mouse()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
			if _main_scene:
				_main_scene.pause_and_open_menu()


func _capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _init_user_preferences() -> void:
	user_prefs = UserPreferences.load_or_create()
	_invert_mouse = user_prefs.invert_mouse
	_invert_gamepad = user_prefs.invert_gamepad


func _init_signals() -> void:
	EventBus.settings_invert_gamepad.connect(on_invert_gamepad_toggle)
	EventBus.settings_invert_mouse.connect(on_invert_mouse_toggle)
	EventBus.pause_game.connect(_release_mouse)
	EventBus.resume_game.connect(_capture_mouse)


func on_invert_mouse_toggle(toggled_on: bool) -> void:
	_invert_mouse = toggled_on


func on_invert_gamepad_toggle(toggled_on: bool) -> void:
	_invert_gamepad = toggled_on


func _physics_process(delta: float) -> void:
	_gamepad_look()
	
	# add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
		velocity.y = clampf(velocity.y, -MAX_FALL_SPEED, MAX_FALL_SPEED)

	# handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = _jump_speed

	var walk_speed : float = _walk_speed
	if is_on_floor():
		_input_dir = Input.get_vector("strafe_left", "strafe_right", "forward", "backward")
		_direction = (transform.basis * Vector3(_input_dir.x, 0, _input_dir.y)).normalized()
		var input_len = _input_dir.length()
		walk_speed = walk_speed * input_len if input_len < 0.8 else walk_speed
		_is_running = true if Input.is_action_pressed("run") else false
		
	var speed := _run_speed if _is_running else walk_speed
	if _direction:
		velocity.x = _direction.x * speed
		velocity.z = _direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, _walk_speed)
		velocity.z = move_toward(velocity.z, 0, _walk_speed)

	move_and_slide()
	_update_stephandler(delta)
	_update_camera()
	_update_spotlight()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * _mouse_sensitivity_x)
		_head.rotate_x(-event.relative.y * _mouse_sensitivity_y * (-1.0 if _invert_mouse else 1.0))
		_head.rotation.x = clampf(_head.rotation.x, MAX_ANGLE_LOOK_DOWN, MAX_ANGLE_LOOK_UP)


func _gamepad_look() -> void:
	var h_look : float = Input.get_axis('look_left', 'look_right')
	var v_look : float = Input.get_axis('look_up', 'look_down')
	rotate_y(-h_look * _gamepad_sensitivity_x)
	_head.rotate_x(-v_look * _gamepad_sensitivity_y * (-1.0 if _invert_gamepad else 1.0))
	_head.rotation.x = clampf(_head.rotation.x, MAX_ANGLE_LOOK_DOWN, MAX_ANGLE_LOOK_UP)


func _update_spotlight() -> void:
	if _spotlight:
		var spotlight_rot_x = _spotlight.rotation.x;
		_spotlight.global_transform = _spotlight.global_transform.interpolate_with(global_transform, 0.08)
		_spotlight.global_position.y = global_position.y + 1.0
		_spotlight.rotation.x = lerpf(spotlight_rot_x, _head.rotation.x, 0.05)

func _init_stephandler() -> void:
	_step_raycast.position.y = _max_step_height
	_step_raycast.target_position.y = -_max_step_height + STEP_HEIGHT_THRESHOLD


func _reset_steptimer(delay: float = 1.0) -> void:
	_step_timer = delay / _step_speed


# followed this tutorial. Revisit if you have issues with ramps
# https://www.youtube.com/watch?v=qjItp1sibiQ
func _update_stephandler(delta: float) -> void:
	_step_timer -= delta
	if abs(_input_dir.length()) > 0.1 and _step_timer <= 0.0:
		_step_handler.rotation.y = atan2(-_input_dir.x, -_input_dir.y)
		if is_on_wall() and is_on_floor() and _step_raycast.is_colliding():
			var collision_point = _step_raycast.get_collision_point()
			var collision_normal = _step_raycast.get_collision_normal()
			if collision_normal.dot(Vector3.UP) > 0.95:
				var step_height : float = collision_point.y - global_position.y
				global_position.y += step_height + 0.05
				_reset_steptimer(step_height)


func _update_camera() -> void:
	if _step_timer <= 0.0:
		_camera.global_transform = _camera_pivot.global_transform
	else:
		var camera_pos_y = _camera.global_position.y
		_camera.global_transform = _camera_pivot.global_transform
		_camera.global_position.y = lerpf(camera_pos_y, _camera_pivot.global_position.y, 0.15)
#		_camera.global_transform = _camera.global_transform.interpolate_with(_camera_pivot.global_transform, 0.1)
