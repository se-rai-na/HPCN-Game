extends Node
signal level_finished(score, timeResult, level)
var functionCalCount = 0

func _load_new_level_data(score, timeResult, level):
	functionCalCount = functionCalCount + 1
	print(str(functionCalCount))
	emit_signal("level_finished", score, timeResult, level)
	
