class_name UserPreferences extends Resource

@export var invert_mouse: bool = false
@export var invert_gamepad: bool = false
@export var fullscreen_enabled: bool = false
@export var vsync_enabled: bool = true
@export_range (10.0, 1000.0, 1.0) var target_fps: float = 60.0


func save() -> void:
	ResourceSaver.save(self, "user://user_prefs.tres")

static func load_or_create() -> UserPreferences:
	print(OS.get_data_dir())
	var res: UserPreferences = load("user://user_prefs.tres") as UserPreferences
	if !res:
		res = UserPreferences.new()
	return res
