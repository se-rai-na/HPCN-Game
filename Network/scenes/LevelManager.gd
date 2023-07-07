#Kirin Hardinger
#Created July 2022
#Seraina Burge
#April 2023
#Func: Added functionality needed for login/register of users
#optimized checkmark functions

extends Node

#when true, allows playing any level without having to complete the previous one
var debug = false
#current user logged in
var user
#flags for respective level completion
#unlocks the next level
#Array that stores bool completion for each level
var flags = []
#dictionaries for the check mark nodes and level nodes
var checkMark_nodes = []
var level_nodes = []
var crown_nodes = []
var scoreDisplay_nodes = []
var highScore_nodes = []
var star1_nodes = []
var star2_nodes = []
var star3_nodes = []
#current level
var level
#dictionary that stores score and time for all the levels
var level_data
#file path for user data
var file_path
#file path for high score
var filepath_highscore = "res://game_data/highscore_tracker.json"
#max scores for the levels
var max_score = [25, 40, 50, 55, 60, 65, 70, 75, 80, 85]
#dictionary for highscore data
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
		#checkMark_nodes.append(get_node("CheckMark" + str(i)))
	# Store references to level nodes
		level_nodes.append(get_node("lvl" + str(i)))
	#Store references to score display nodes
		scoreDisplay_nodes.append(get_node("UserScore"+(str(i))))
		highScore_nodes.append(get_node("highScore"+(str(i))))
	#Store references to crown display
		crown_nodes.append(get_node("lvl" + str(i) + "/crown" + str(i)))
	#initiate star node
		star1_nodes.append(get_node("lvl" + str(i) + "/Star1"))
		star2_nodes.append(get_node("lvl" + str(i) + "/Star1/Star2"))
		star3_nodes.append(get_node("lvl" + str(i) + "/Star1/Star3"))
	#Connects to the HUD script in order to get the score values using a glibal signal
	SignalBus.connect("level_finished", self, "_on_player_value_added", [])

	hide_buttons()

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
	user = username
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
		if level_data[str(i+1)]["time"] != 0:
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
	
#adds level data of newly played levels to the level_data array -> connects from HUD via SignalBus
func _on_player_value_added(score, timer, _level):
	level_data[str(_level)]["time"] = timer
	level_data[str(_level)]["score"] = score
	print(str(level_data[str(_level)]["score"]))
	print(str(level_data[str(_level)]["time"]))
	check_highscore(score, timer, _level)
	#print(level_data)
	save_dictionary_to_json()
	
func save_dictionary_to_json():
	var json_data := JSON.print(level_data)
	var file := File.new()
	if file.open(file_path, File.WRITE) == OK:
		file.store_string(json_data)
	else:
		print("Failed to open file for writing:", file_path)
	file.close()	

func display():
	show_buttons()
	set_crown()
	set_username()
	set_checks()
	set_star()

func set_checks():
	#checks for each levels
	for i in range (0, 10):
		if flags[i]:
			#checkMark_nodes[i].show()
			star1_nodes[i].show()
			level_nodes[i].disabled = false
			scoreDisplay_nodes[i].text = str(level_data[str(i+1)]["score"])
			#var highscore_string = ""
			var highscore_string = highscore_data[str(i+1)]["user"]
			if len(highscore_string) != 0:
				#shows message of highScore for levels that have been played before
				highScore_nodes[i].text = str(highscore_data[str(i+1)]["user"]) + ": " + str(highscore_data[str(i+1)]["score"]) 
		#make sure the new level does not have a checkmark
		elif not flags[i] and flags[i - 1]:
			star1_nodes[i].show()
			#checkMark_nodes[i-1].hide()
	#var user = str(highscore_data["1"]["user"])
	#var score_user = str(highscore_data["1"]["score"])
	#$highScore1.text = user + ": " + score_user

func get_highscore_data():
	var file = File.new()
	if file.open(filepath_highscore, File.READ) != OK:
		print("File " + str(filepath_highscore) + " could not be opened.")
		return
	var json_string = file.get_as_text()
	file.close()
	highscore_data = JSON.parse(json_string).result
#checks if recent score is new highscore and adds it to the highscore 
#if that is the case
func check_highscore(score, timer, _level):
	if highscore_data[str(_level)]["score"] < score:
		highscore_data[str(_level)]["user"] = user
		highscore_data[str(_level)]["score"] = score
		highscore_data[str(_level)]["time"] = timer
		save_new_highScore()
	elif highscore_data[str(_level)]["score"] == score:
		if highscore_data[str(_level)]["time"] < timer:
			highscore_data[str(_level)]["user"] = user
			highscore_data[str(_level)]["score"] = score
			highscore_data[str(_level)]["time"] = timer
			save_new_highScore()
		else:
			return 
func save_new_highScore():
	var json := JSON.print(highscore_data)
	var file = File.new()
	if file.open(filepath_highscore, File.WRITE) == OK:
		file.store_string(json)
	else:
		print("Failed to open file for writing:", file_path)
	file.close()
#checks if user has the global highscore in a level and 
#makes the crown visible
func set_crown():
	for i in range(1, max_level-1 + 1):
		if highscore_data[str(i)] ["user"] == user:
			crown_nodes[i-1].show()
			

func set_username():
	$username.text = "Hi, " + str(user) + "!"
	$username.show()

func set_star():
	for i in range(0, max_level-1 + 1):
		#print("number " + str(i))
		var score = level_data[str(i+1)]["score"]
		if score != 0:
			var max_scores = max_score[i]
			star1_nodes[i].show()
			if score > max_scores / 3:
				star2_nodes[i].show()
			if score > max_scores / 3 * 2:
				star3_nodes[i].show()
		elif score == 0:
			star1_nodes[i].hide()

#connects to StartScreen :: _ready()
#returns to the start screen
#func _on_X_pressed():
#	hide_buttons()
#	hide_checks()
#	emit_signal("back_pressed")

func show_buttons():
	get_tree().call_group("lvlButtons", "show")
	get_tree().call_group("UserScore", "show")
	get_tree().call_group("HighScore", "show")

func hide_buttons():
	get_tree().call_group("lvlButtons", "hide")
	get_tree().call_group("UserScore", "hide")
	get_tree().call_group("HighScore", "hide")
	get_tree().call_group("Crown", "hide")
	$username.hide()

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
	emit_signal("one_pressed")

func _on_lvl2_pressed():
	hide_buttons()
	emit_signal("two_pressed")

func _on_lvl3_pressed():
	hide_buttons()
	emit_signal("three_pressed")

func _on_lvl4_pressed():
	hide_buttons()
	emit_signal("four_pressed")

func _on_lvl5_pressed():
	hide_buttons()
	emit_signal("five_pressed")

func _on_lvl6_pressed():
	emit_signal("six_pressed")
	hide_buttons()

func _on_lvl7_pressed():
	emit_signal("seven_pressed")
	hide_buttons()

func _on_lvl8_pressed():
	emit_signal("eight_pressed")
	hide_buttons()

func _on_lvl9_pressed():
	emit_signal("nine_pressed")
	hide_buttons()

func _on_lvl10_pressed():
	emit_signal("ten_pressed")
	hide_buttons()

func _on_logout_pressed():
	save_dictionary_to_json()
	#level_data = null
	#file_path = null
	hide_buttons()
	emit_signal("back_pressed")
	
