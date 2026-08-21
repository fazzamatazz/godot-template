extends HSlider

@export var label : Label


func _ready() -> void:
	setLabelFPS(value)


func setLabelFPS(fps: float) -> void:
	if fps <= 0.0:
		label.text = 'TARGET FPS:  N/A'
	else:
		label.text = 'TARGET FPS:  ' + str(int(fps))
