extends HSlider

@export var label : Label
@export var label_text : String = 'TARGET FPS:  '


func _ready() -> void:
	setLabelValue(value)


func setLabelValue(fps: float) -> void:
	if fps <= 0.0:
		label.text = label_text + '  N/A'
	else:
		label.text = label_text + str(int(fps))


func disableSlider() -> void:
	label.add_theme_color_override('font_color', Color('#dfdfdf80'))
	editable = false


func enableSlider() -> void:
	label.remove_theme_color_override('font_color')
	editable = true
