extends HSlider

@export var label : Label
@export var label_text : String = 'VOLUME:  '


func _ready() -> void:
	setLabelValue(value)


func setLabelValue(fps: float) -> void:
	label.text = label_text + str(int(fps))
