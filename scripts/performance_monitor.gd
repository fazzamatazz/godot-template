class_name PerformanceMonitor extends Control

## Set whether the Performance Monitor should run and display data in the parented HUD
@export var _enabled := true
## Set whether to display extra performance data
@export var _verbose := false
## Set whether vsync and Max FPS should be disabled, allowing game to run unthrottled, OS permitting.
@export var _disable_limiters := false
## Set how often to update the performance metrics
@export var _update_tick := 0.5

@onready var _label := %Label

# FRAME
var fps : int
var frame_time_ms : float
var fps_equivalent : int
var physics_fps : int
# RENDERING
var draw_calls : int
var triangles : int
var objects : int
# MEMORY
var static_memory_mb : float
var static_memory_peak_mb : float
var video_memory_mb : float
# SCENE
var total_nodes : int
var visible_nodes : int
# PHYSICS
var physics_objects : int
var collision_pairs : int
# TIMER
var _update_timer := 0.0


func _ready() -> void:
	if !_enabled:
		_label.text = ""
	else:
		if _disable_limiters:
			Engine.max_fps = 0
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


func _process(delta: float) -> void:
	if _enabled && _label:
		_update_timer += delta
		if _update_timer < _update_tick:
			return
		_update_timer = 0.0
		_update_variables(delta)
		_update_label()


func _update_label() -> void:
	_label.text = "FPS".rpad(27) + "%.0f" % fps
	_label.text += "\nframe_time".rpad(20) + "%.1f ms" % frame_time_ms
	if _verbose:
		_label.text += " (%.0f)" % fps_equivalent
	_label.text += "\nphysics FPS".rpad(21) + "%.0f" % physics_fps
	_label.text += "\ndraw calls".rpad(23) + "%.0f" % draw_calls
	if _verbose:
		_label.text += "\ntriangles".rpad(24) + "%.0f" % triangles
		_label.text += "\nobjects".rpad(25) + "%.0f" % objects
	_label.text += "\nstatic mem".rpad(21) + "%.0f mb" % static_memory_mb
	if _verbose:
		_label.text += ", max %.0f mb" % static_memory_peak_mb
	_label.text += "\nvideo mem".rpad(20) + "%.0f mb" % video_memory_mb
	_label.text += "\nnodes".rpad(25) + "%.0f" % total_nodes
	if _verbose:
		_label.text += ", visible %.0f" % visible_nodes
		_label.text += "\nphysics objects".rpad(19) + "%.0f" % physics_objects
		_label.text += "\ncollision pairs".rpad(22) + "%.0f" % collision_pairs


func _update_variables(delta: float) -> void:
	
	frame_time_ms = Performance.get_monitor(Performance.TIME_PROCESS) * 1000.0
	fps_equivalent = 1000.0 / frame_time_ms
	fps = Performance.get_monitor(Performance.TIME_FPS)
	physics_fps = Engine.physics_ticks_per_second
	
	draw_calls = RenderingServer.get_rendering_info(
		RenderingServer.RENDERING_INFO_TOTAL_DRAW_CALLS_IN_FRAME
	)
	
	static_memory_mb = Performance.get_monitor(
		Performance.MEMORY_STATIC
	) / 1024.0 / 1024.0
	
	video_memory_mb = Performance.get_monitor(
		Performance.RENDER_VIDEO_MEM_USED
	) / 1024.0 / 1024.0

	total_nodes = Performance.get_monitor(
		Performance.OBJECT_NODE_COUNT
	)
	
	if _verbose:
		triangles = RenderingServer.get_rendering_info(
			RenderingServer.RENDERING_INFO_TOTAL_PRIMITIVES_IN_FRAME
		)
		
		objects = RenderingServer.get_rendering_info(
			RenderingServer.RENDERING_INFO_TOTAL_OBJECTS_IN_FRAME
		)
		
		static_memory_peak_mb = Performance.get_monitor(
			Performance.MEMORY_STATIC_MAX
		) / 1024.0 / 1024.0
		
		visible_nodes = _count_visible_nodes(get_tree().current_scene)
		
		physics_objects = Performance.get_monitor(
			Performance.PHYSICS_3D_ACTIVE_OBJECTS
		)
		
		collision_pairs = Performance.get_monitor(
			Performance.PHYSICS_3D_COLLISION_PAIRS
		)


func _count_visible_nodes(node: Node) -> int:
	var count := 0
	if node is VisualInstance3D:
		if node.visible:
			count += 1
	for child in node.get_children():
		count += _count_visible_nodes(child)
	return count
