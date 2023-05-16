extends Node
signal level_finished(score, timeResult)

func _load_new_level_data(score, timeResult):
	emit_signal("level_finished", score, timeResult)
