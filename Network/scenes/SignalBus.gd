extends Node
signal level_finished(score, timeResult, level)
signal log_in()
var functionCalCount = 0
#used to connect HUD with LevelManager whenever a level is completed
#in order to transfer scores
func _load_new_level_data(score, timeResult, level):
	functionCalCount = functionCalCount + 1
	emit_signal("level_finished", score, timeResult, level)
#used in order to connect Register and Login nodes, 
#so user logs in after registering anew account
func _load_log_in():
	emit_signal("log_in")
