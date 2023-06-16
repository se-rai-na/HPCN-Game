#Kirin Hardinger
#Created July 2022
#Seraina Burge
#April 2023
#Func: Added functionality needed for login/register of users
#optimized checkmark functions

extends Node

#when true, allows playing any level without having to complete the previous one
var debug = false

#flags for respective level completion
#unlocks the next level
#Array that stores bool completion for each level
var flags = []
#dictionaries for the check mark nodes and level nodes
var checkMarks = []
var levels = []
#dictionary for the score displat
var scoreDisplay = []
var highScore = []

var level
#gets username that is used to access file

var level_data
var file_path
var highscore_data

#there are 10 levels
var max_level = 10

#returns to StartScreen node
signal back_pressed


#signals that connect back to the respective function in the Main node
#starts the respective level
signal one_pressed
signal two_pressed
signal three_pressed
signal four_pressed
signal five_pressed
signal six_pressed
signal seven_pressed
signal eight_pressed
signal nine_pressed
signal ten_pressed

func _ready():
	get_highscore_data()
	#var hud = get_node_or_null("HUD")
   # Store references to check mark nodes
	for i in range(1, max_level+1):
		checkMarks.append(get_node("CheckMark" + str(i)))
	# Store references to level nodes
	for i in range(1, max_level+1):
		levels.append(get_node("lvl" + str(i)))
	#Store references to score display nodes
	for i in range(1, max_level+1):
		scoreDisplay.append(get_node("UserScore"+(str(i))))
		highScore.append(get_node("highScore"+(str(i))))
	#Connects to the HUD script in order to get the score values using a glibal signal
	SignalBus.connect("level_finished", self, "_on_player_value_added", [], CONNECT_ONESHOT)

	hide_buttons()
	hide_checks()
	# Loop through all child nodes of the current node
	for child in get_children():
		# Check if the child node's name contains "lvl"
		if "lvl" in child.get_name():
			# Disable the child node
			child.set_disabled(true)
	#$Login.connect("logged_in", self, "_on_Login_logged_in")


#appears when user is successfully logged in
#or returns to the menu
func _on_Login_logged_in(username):
	file_path = "res://game_data/user_data/" + str(username) + ".json"
	print("LOGGED IN LEVEL SELECTION " + str(username))
	#if not debug:
	#check status of all levels
	set_level_status()
	#display the level buttons
	display()
		
#flags each level depending on completed/ not completed
func set_level_status():
	#deserialize json file with user data into a dictionary 
	#within a dictionary
	get_user_data()
	#check levels if the value for time is 0
	#level has not been completed
	var node_path
	#used to get the current level the player is on
	var newest_level = false
	for i in range(0, max_level-1 + 1):
		print("level" + str(i+1))
		
		if level_data[str(i+1)]["time"] != 0:
			print(str(level_data[str(i+1)]["time"]))
			#appends bool for level completion to flags array
			flags.append(true)
		else:
			if not newest_level:
				#level has not been played yet but is the current level
				newest_level = true
				#set flag to disable button to true
				flags.append(true)
			else:
				#level has not been played yet and is not the current level
				flags.append(false)


#deserialized json file
func get_user_data():
	var file = File.new()
	if file.open(file_path, File.READ) != OK:
		print("File " + str(file_path) + " could not be opened.")
		return
	var json_string = file.get_as_text()
	file.close()
	level_data = JSON.parse(json_string).result
	print(level_data) # Print the contents of level_data
	
#adds level data of newly played levels to the level_data array
func _on_player_value_added(score, timer, _level):
	print("PLAYER VALUE ADDED")
	print(level_data)
	print("score" + str(score) + "time" + str(timer) + "level" + str(_level)) 
	level_data[str(_level)]["time"] = timer
	level_data[str(_level)]["score"] = score
	print(level_data)
	save_dictionary_to_json()
	
func save_dictionary_to_json():
	var json_data := JSON.print(level_data)
	var file := File.new()
	if file.open(file_path, File.WRITE) == OK:
		file.store_string(json_data)
		file.close()
	else:
		print("Failed to open file for writing:", file_path)
	

func display():
	print("Display in LevelSelection")
	show_buttons()
	#checks for each levels
	for i in range (0, flags.size()):
		if flags[i]:
			print("flag", i+1, "is true")
			checkMarks[i].show()
			levels[i].disabled = false
			scoreDisplay[i].text = str(level_data[str(i+1)]["score"])
			#var highscore_string = ""
			var highscore_string = highscore_data[str(i+1)]["user"]
			if len(highscore_string) != 0:
				highScore[i].text = str(highscore_data[str(i+1)]["user"]) + ": " + str(highscore_data[str(i+1)]["score"]) 
		#make sure the new level does not have a checkmark
		elif not flags[i] and flags[i - 1]:
			checkMarks[i-1].hide()
	#var user = str(highscore_data["1"]["user"])
	#var score_user = str(highscore_data["1"]["score"])
	#$highScore1.text = user + ": " + score_user

func get_highscore_data():
	var file = File.new()
	if file.open("res://game_data/highscore_tracker.json", File.READ) != OK:
		print("File " + str(file_path) + " could not be opened.")
		return
	var json_string = file.get_as_text()
	file.close()
	highscore_data = JSON.parse(json_string).result
	print(highscore_data)

#connects to StartScreen :: _ready()
#returns to the start screen
func _on_X_pressed():
	hide_buttons()
	hide_checks()
	emit_signal("back_pressed")

func show_buttons():
	get_tree().call_group("lvlButtons", "show")
	get_tree().call_group("UserScore", "show")
	$highScore1.show()
	$X.show()

func hide_buttons():
	get_tree().call_group("lvlButtons", "hide")
	get_tree().call_group("UserScore", "hide")
	$highScore1.hide()
	$X.hide()

func hide_checks():
	get_tree().call_group("checks", "hide")
	
#called by _comp(var level) function in Main node
func set_flag(_level):
	match _level:
		1:
			flags[0] = true
		2:
			flags[1] = true
		3:
			flags[2] = true
		4:
			flags[3] = true
		5:
			flags[4] = true
		6:
			flags[5] = true
		7:
			flags[6] = true
		8:
			flags[7]= true
		9:
			flags[8] = true
		10:
			flags[9] = true

#on level buttons pressed
#each one connects to the respective level function in the Main node to start the level
func _on_lvl1_pressed():
	hide_buttons()
	hide_checks()
	emit_signal("one_pressed")

func _on_lvl2_pressed():
	hide_buttons()
	hide_checks()
	emit_signal("two_pressed")

func _on_lvl3_pressed():
	hide_buttons()
	hide_checks()
	emit_signal("three_pressed")

func _on_lvl4_pressed():
	hide_buttons()
	hide_checks()
	emit_signal("four_pressed")

func _on_lvl5_pressed():
	hide_buttons()
	hide_checks()
	emit_signal("five_pressed")

func _on_lvl6_pressed():
	emit_signal("six_pressed")
	hide_buttons()
	hide_checks()

func _on_lvl7_pressed():
	emit_signal("seven_pressed")
	hide_buttons()
	hide_checks()

func _on_lvl8_pressed():
	emit_signal("eight_pressed")
	hide_buttons()
	hide_checks()

func _on_lvl9_pressed():
	emit_signal("nine_pressed")
	hide_buttons()
	hide_checks()

func _on_lvl10_pressed():
	emit_signal("ten_pressed")
	hide_buttons()
	hide_checks()

func _on_logout_pressed():
	save_dictionary_to_json()
	level_data = null
	file_path = null
	scoreDisplay = null
	hide_buttons()
	hide_checks()
	emit_signal("back_pressed")
	
