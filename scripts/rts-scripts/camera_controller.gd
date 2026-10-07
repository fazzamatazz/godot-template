extends Camera3D

var height_max := 160.0
var height_min := 10.0
var height := 50.0
var scroll_sensitivity := 0.002

func _ready() -> void:
	fov = 25.0
	rotation.x = deg_to_rad(-60.0)
	translate_object_local(Vector3(0, 0, height))


func move_by(x: float, y: float) -> void:
	position.x -= x * scroll_sensitivity * height
	position.z -= y * scroll_sensitivity * height


func zoom_in() -> void:
	var step := 5.0
	if height >= 100.0:
		step = 20.0
	elif height >= 50.0:
		step = 10.0
	var height_new = clampf(height - step, height_min, height_max)
	if height_new != height:
		height = height_new
		translate_object_local(Vector3(0, 0, -step))


func zoom_out() -> void:
	var step := 5.0
	if height >= 100.0:
		step = 20.0
	elif height >= 50.0:
		step = 10.0
	var height_new = clampf(height + step, height_min, height_max)
	if height_new != height:
		height = height_new
		translate_object_local(Vector3(0, 0, step))
