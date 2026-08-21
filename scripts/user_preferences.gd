class_name UserPreferences extends Resource

@export var invert_mouse: bool = false
@export var invert_gamepad: bool = false
@export var fullscreen_enabled: bool = false
@export var vsync_enabled: bool = true
@export_range (0.0, 1000.0, 1.0) var target_fps: float = 60.0
@export_range (0.0, 100.0, 5.0) var master_volume: float = 100.0
@export_range (0.0, 100.0, 5.0) var music_volume: float = 100.0
@export_range (0.0, 100.0, 5.0) var sound_volume: float = 100.0
@export_range (0.0, 100.0, 1.0) var mouse_sensitivity: float = 25.0
@export_range (0.0, 100.0, 1.0) var gamepad_sensitivity: float = 50.0

func save() -> void:
	ResourceSaver.save(self, "user://user_prefs.tres")

static func load_or_create() -> UserPreferences:
	print(OS.get_data_dir())
	var res: UserPreferences = load("user://user_prefs.tres") as UserPreferences
	if !res:
		res = UserPreferences.new()
	return res
