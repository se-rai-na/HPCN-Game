#Kirin Hardinger
#Created July 2022
#Seraina Burge
#April 2023
#Func: Added functionality needed for login/register of users

extends Node

#when true, allows playing any level without having to complete the previous one
var debug = false

#flags for respective level completion
#unlocks the next level
#Array that stores bool completion for each level
var flags = []


#gets username that is used to access file

var level_data
var file_path
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
	print("LeveleSelectionReadyFunction")
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
	print("Got user data")
	print(str(level_data["1"]["time"]))
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

func display():
	print("Display in LevelSelection")
	show_buttons()
	#checks for each levels
	if flags[0]:
		print("flag 1 is true")
		$CheckMark.show()
		$lvl1.disabled = false
	if flags[1]:
		print("flag 2 is true")
		$CheckMark2.show()
		$lvl2.disabled = false
	if flags[2]:
		print("flag 3 is true")
		$CheckMark3.show()
		$lvl3.disabled = false
	if flags[3]:
		$CheckMark4.show()
		$lvl4.disabled = false
	if flags[4]:
		$CheckMark5.show()
		$lvl5.disabled = false
	if flags[5]:
		$CheckMark6.show()
		$lvl6.disabled = false
	if flags[6]:
		$CheckMark7.show()
		$lvl7.disabled = false
	if flags[7]:
		$CheckMark8.show()
		$lvl8.disabled = false
	if flags[8]:
		$CheckMark9.show()
		$lvl9.disabled = false
	if flags[9]:
		$CheckMark10.show()
		$lvl10.disable = false
	print("checked all")

#connects to StartScreen :: _ready()
#returns to the start screen
func _on_X_pressed():
	hide_buttons()
	hide_checks()
	emit_signal("back_pressed")

func show_buttons():
	get_tree().call_group("lvlButtons", "show")
	$X.show()

func hide_buttons():
	get_tree().call_group("lvlButtons", "hide")
	$X.hide()

func hide_checks():
	get_tree().call_group("checks", "hide")
	
#called by _comp(var level) function in Main node
func set_flag(var level):
	match level:
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


