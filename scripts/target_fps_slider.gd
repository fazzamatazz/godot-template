extends HSlider

const VALUE_MAP := [
	24, 30, 40, 45, 50, 60, 72, 75, 90, 100, 120,
	144, 165, 180, 200, 240, 300, 360, 480,
	500, 540, 600, 720, 0
]

@export var label : Label
@export var label_text : String = 'TARGET FPS:  '


func getMappedValue() -> float:
	return float(VALUE_MAP[value])


func getMappedValueFromIndex(index: float) -> int:
	var i : int = int(index)
	if i < 0:
		i = 0
	if i >= VALUE_MAP.size():
		i = VALUE_MAP.size() - 1
	return VALUE_MAP[i]


func getIndexOfMappedValue(v: float) -> int:
	return VALUE_MAP.find(int(v))


func updateLabel() -> void:
	var v = getMappedValueFromIndex(value)
	if v == 0:
		label.text = label_text + 'UNLIMITED'
	else:
		label.text = label_text + str(int(v))


func setSliderIndexFromMappedValue(v: float) -> void:
	var index = getIndexOfMappedValue(v)
	if index < 0 or index >= VALUE_MAP.size():
		index = 5
	value = index


func disableSlider() -> void:
	label.add_theme_color_override('font_color', Color('#dfdfdf80'))
	label.text = label_text + '  N/A'
	editable = false


func enableSlider() -> void:
	label.remove_theme_color_override('font_color')
	editable = true
