extends Control

var usernameInput
var passwordInput
var pwdInput
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print("start")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func check_password():
	print("check password")
	if passwordInput == pwdInput:
		check_username()
	else:
		$message.text = "Passwords must match!"
		clearUserInput()
		return
	
func check_username():
	var file = File.new()
	if file.open("res://game_data/user_database.json", File.READ) != OK:
		print("Failed to open file")
		return
	var contents = file.get_as_text()
	file.close()

	# Parse the JSON file into a dictionary
	var credentials = JSON.parse(contents).result
	if credentials.has(usernameInput):
		$message.text = "Username is taken."
		clearUserInput()

func _on_Button_pressed():
	print("BUTTON PRESSED")
	usernameInput = $userNameInput.get_text()
	passwordInput = $passwordInput.get_text()
	pwdInput = $passwordAgainInput.get_text()
	check_password()
	#if both username and password are valid
	newUserFile()
	addUserDatabase()
	
#Creates a new JSON file for the user to save users fame data
func newUserFile():
	#creates a new file path with the username as the file name
	var file_path = "res://game_data/user_data/" + usernameInput + ".json"
	#creating a new file object
	var file = File.new()
	# Open the file in write mode
	file.open(file_path, File.WRITE)
	# Close the file
	file.close()
	
#adds username and password to the user_data JSON file
func addUserDatabase():
	#get the filepath
	var file_path = "res://game_data/user_database.json"
	#create a new file object
	var file = File.new()
	#open the file in write mode
	file.open(file_path, File.write)
	#create a dictionary with the user info
	var user_info = {
		"username": usernameInput,
		"password": passwordInput
	}
	#convert it to a JSON string
	var json_string = JSON.print(user_info)
	#append user_info to the file
	file.append_string(json_string)
	#close the file
	file.close()
	
	
func clearUserInput():
	$userNameInput.clear()
	$passwordInput.clear()
	$passwordAgainInput.clear()
	
