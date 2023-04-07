#Kirin Hardinger
#Created July 2022

extends Node

#connects to LevelSelectionScreen :: dispay()
#moves to level selection screen
signal level

#sets which level is active
#used in _on_PauseScreen_exit_pause() function which exits the appropriate level when the user exits
var active_1 = false
var active_2 = false
var active_3 = false
var active_4 = false
var active_5 = false
var active_6 = false
var active_7 = false
var active_8 = false
var active_9 = false
var active_10 = false
#level functions
#each one is connected to the respective function from the LevelSelectionScreen node
#the pause screen is enabled to allow the user to pause the game while within a level
#the functions then set the active scene and load an instance
func level_1():
	active_1 = true
	$PauseScreen.enable()
	add_child(load("res://levels//Level_1.tscn").instance())
	
func level_2():
	active_2 = true
	$PauseScreen.enable()
	add_child(load("res://levels//Level_2.tscn").instance())

func level_3():
	active_3 = true
	$PauseScreen.enable()
	add_child(load("res://levels//Level_3.tscn").instance())
	
func level_4():
	active_4 = true
	$PauseScreen.enable()
	add_child(load("res://levels//Level_4.tscn").instance())

func level_5():
	active_5 = true
	$PauseScreen.enable()
	add_child(load("res://levels//Level_5.tscn").instance())
	
func level_6():
	active_6 = true
	$PauseScreen.enable()
	add_child(load("res://levels//Level_6.tscn").instance())
	
func level_7():
	active_7 = true
	$PauseScreen.enable()
	add_child(load("res://levels//Level_7.tscn").instance())
	
func level_8():
	active_8 = true
	$PauseScreen.enable()
	add_child(load("res://levels//Level_8.tscn").instance())

func level_9():
	active_9 = true
	$PauseScreen.enable()
	add_child(load("res://levels//Level_9.tscn").instance())

func level_10():
	active_10 = true
	$PauseScreen.enable()
	add_child(load("res://levels//Level_10.tscn").instance())

#complete level function is called upon the completion of each level
#this sets the respective flag in the LevelSelectionScreen node which then allows the player to start the next level
#the pause screen is disabled and the "level" signal is eted in order to show the level selection screen again
func _comp(var level):
	print("LEVEL COMPLETE")
	print(str(level))
	level += 1
	$LevelSelectionScreen.set_flag(level)
	$PauseScreen.disable()
	emit_signal("level")

#if the player chooses to pause the game within a level and exit the level before completing it, this function removes the instance of the scene
#the scene then returns to the level selection screen
func _on_PauseScreen_exit_pause():
	if active_1:
		remove_child(get_node("Level_1"))
	if active_2:
		remove_child(get_node("Level_2"))
	if active_3:
		remove_child(get_node("Level_3"))
	if active_4:
		remove_child(get_node("Level_4"))
	if active_5:
		remove_child(get_node("Level_5"))
	if active_6:
		remove_child(get_node("Level_6"))
	if active_7:
		remove_child(get_node("Level_7"))
	if active_8:
		remove_child(get_node("Level_8"))
	if active_9:
		remove_child(get_node("Level_9"))
	if active_10:
		remove_child(get_node("Level_10"))
	$PauseScreen.disable()
	emit_signal("level")
