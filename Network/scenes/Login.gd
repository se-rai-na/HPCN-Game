#Seraina Burge
#March 2023
#Login script

extends Node
# Declare variables for our two line edit nodes
var usernameInput
var passwordInput

signal logged_in
signal register


		
func check_login():
	print("check_login called")
	# Load the JSON file containing our valid usernames and passwords
	var file = File.new()
	if file.open("res://game_data/user_database.json", File.READ) != OK:
		print("Failed to open file")
		return
	var contents = file.get_as_text()
	file.close()

	# Parse the JSON file into a dictionary
	var credentials = JSON.parse(contents).result
	print(credentials["aniares"])
	var _input

	# Check if the current input matches any valid username/password pairs
	if credentials.has(usernameInput) and credentials[usernameInput] == passwordInput:
		print("TRUE")
		# Login successful!
		$loginSuccess.text = "Login successful"
		return

	# If we get here, no matching username/password pair was found
	else:
		$loginSuccess.text = "Login unsuccessful"
		$passwordInput.clear()

func _on_send_pressed():
	print("check_login called1")

	
	# Find the usernameInput and passwordInput nodes by name
	usernameInput = $usernameInput.get_text()
	passwordInput = $passwordInput.get_text()
	print(usernameInput)
	print(passwordInput)
	# Connect the line edit nodes to our function that will check their input
	#usernameInput.connect("text_entered", self, "check_login")
	#passwordInput.connect("text_entered", self, "check_login")
	check_login()
	#if log in is correct
	#hide login nodes
	hide()
	#signal logged in
	emit_signal("logged_in")



#emits signal to register script when user creates new account
func _on_newAccount_pressed():
	#emit signal to get the register scen
	emit_signal("register")
	#hide login elements
	hide()

func _on_StartScreen_play_pressed():
	print("Login screen")
	$login.show()
	$newAccount.show()
	$userName.show()
	$usernameInput.show()
	$password.show()
	$passwordInput.show()
	$loginSuccess.show()
	$send.show()
	
func hide():
	$login.hide()
	$newAccount.hide()
	$userName.hide()
	$usernameInput.hide()
	$password.hide()
	$passwordInput.hide()
	$loginSuccess.hide()
	$send.hide()
	


