extends HSlider

@export var label : Label


func _ready() -> void:
	setLabelFPS(value)


func setLabelFPS(fps: float) -> void:
	label.text = 'TARGET FPS:  ' + str(int(fps))
