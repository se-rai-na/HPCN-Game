#Seraina Burge
#March 2023
#Register script

extends Node

var usernameInput
var passwordInput
var pwdInput
var contents

signal log_in

# Called when the node enters the scene tree for the first time.

onready var http = $HTTPRequest
onready var dhttp = $DatabaseHTTPRequest
#checks if the two password entries match
func check_password():
	print("check password")
	if passwordInput == pwdInput:
		check_username()
	else:
		$message.text = "Passwords must match!"
		clearUserInput()
		return
#checks if the username already exists
func check_username():
	var file = File.new()
	if file.open("res://game_data/user_database.json", File.READ) != OK:
		print("Failed to open file")
		return
	contents = file.get_as_text()
	file.close()

	# Parse the JSON file into a dictionary
	var credentials = JSON.parse(contents).result
	if credentials.has(usernameInput):
		$message.text = "Username is taken."
		clearUserInput()
	return
#gets the user input when the user clicks send
func _on_Button_pressed():
	print("BUTTON PRESSED")
	usernameInput = $userNameInput.get_text()
	passwordInput = $passwordInput.get_text()
	pwdInput = $passwordAgainInput.get_text()
	if not passwordInput or not usernameInput or passwordInput != pwdInput:
		$message.text = "Invalid password/username"
		return
	Firebase.register(usernameInput, passwordInput, http)
	#check password
	#check_password()
	#print("Username/password checked")
	#if both username and password are valid creates a new file for the suer data
	#newUserFile()
	print("new File generated")
	#add user with username and password to the user database file
	#addUserDatabase()
	print("added to user base")
	#when everything is done, user is asked to log into account
	yield(get_tree().create_timer(2.0), "timeout")
	SignalBus._load_log_in()
	hide()
	clearUserInput()
	
#Creates a new JSON file for the user to save users fame data
func newUserFile():
	#creates a new file path with the username as the file name
	var file_path = "res://game_data/user_data/" + usernameInput + ".json"
	var json_data = {}
	for i in range(1, 11):
		json_data[str(i)] = {"time": 0, "score": 0}  
	var json_text = JSON.print(json_data)
	#creating a new file object
	var file = File.new()
	# Open the file in write mode
	file.open(file_path, File.WRITE)
	file.store_string(json_text)
	# Close the file
	file.close()
	
#adds username and password to the user_data JSON file
func addUserDatabase():
	#get the filepath
	var file_path = "res://game_data/user_database.json"
	#create a new file object
	var file = File.new()
	var userData
	#open the file in read mode to extract
	if file.open(file_path, File.READ) == OK:
		#extract contents as a dictionary
		var jsonContent = file.get_as_text()
		file.close()
		#using JSON data to generate a dictionary
		userData = JSON.parse(jsonContent).result
		print(userData)
		#adding the new username and its password
		userData[str(usernameInput)] = str(passwordInput)
	if file.open(file_path, File.WRITE) == OK:
		#serializign json string
		var json_string = JSON.print(userData)
		#storing new data
		file.store_string(json_string)
		file.close()
	
func clearUserInput():
	$userNameInput.clear()
	$passwordInput.clear()
	$passwordAgainInput.clear()

func hide():
	$message.hide()
	$register.hide()
	$userNameInput.hide()
	$userName.hide()
	$passwordInput.hide()
	$password.hide()
	$passwordAgain.hide()
	$passwordAgainInput.hide()
	$send.hide()
	
#show all the nodes when
func _on_Login_register():
	$message.show()
	$register.show()
	$userNameInput.show()
	$userName.show()
	$passwordInput.show()
	$password.show()
	$passwordAgain.show()
	$passwordAgainInput.show()
	$send.show()


func _on_HTTPRequest_request_completed(result, response_code, headers, body: PoolByteArray):
	print("on http singal func")
	var resp_body = JSON.parse(body.get_string_from_ascii())
	if response_code != 200:
		$message.text = resp_body.result.error.message.capitalize()
	else:
		$message.text = "Account Created Successfully!"
		Firebase.new_user(usernameInput, dhttp)
	

	


func _on_DatabaseHTTPRequest_request_completed(result, response_code, headers, body):
	print("On database")
	print(response_code)# Replace with function bod
	var resp_body = JSON.parse(body.get_string_from_ascii())
	print(resp_body.result)
