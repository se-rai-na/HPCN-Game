#Seraina Burge
#March 2023
#Login script

extends Node
# Declare variables for our two line edit nodes
var usernameInput
var passwordInput

signal logged_in(username)
signal register


func _ready():
	SignalBus.connect("log_in", self, "_on_button_pressed")
	
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
	var _input
	
	var correct_login
	# Check if the current input matches any valid username/password pairs
	if credentials.has(usernameInput) and credentials[usernameInput] == passwordInput:
		print("good password/ username")
		#Delete data from the input field
		$passwordInput.clear()
		$usernameInput.clear()
		correct_login = true
		return(correct_login)
	#no matching password/username pai was found
	#1 username exists but password is incorrect
	elif credentials.has(usernameInput) and credentials[usernameInput] != passwordInput:
		print("Wrong password")
		$passwordInput/password_unsuccessful.show()
		$passwordInput.clear()
		correct_login = false
		return(correct_login)
	#2 username also does not exist
	elif !credentials.has(usernameInput):
		print("wrong username/ password")
		$usernameInput/username_unsuccessful.show()
		$passwordInput.clear()
		$usernameInput.clear()
		correct_login = false
		return(correct_login)
		

func _on_send_pressed():
	# Find the usernameInput and passwordInput nodes by name
	usernameInput = $usernameInput.get_text()
	passwordInput = $passwordInput.get_text()
	print(usernameInput)
	print(passwordInput)
	# Connect the line edit nodes to our function that will check their input
	#usernameInput.connect("text_entered", self, "check_login")
	#passwordInput.connect("text_entered", self, "check_login")
	var correct_login = check_login()
	#if log in is correct
	#hide login nodes
	if correct_login:
		hide()
		#signal logged in and send the username
		emit_signal("logged_in", usernameInput)


#emits signal to register script when user creates new account
func _on_newAccount_pressed():
	#emit signal to get the register scen
	emit_signal("register")
	#hide login elements
	hide()

func _on_button_pressed():
	print("Login screen")
	$login.show()
	$newAccount.show()
	$usernameInput/userName.show()
	$usernameInput.show()
	$passwordInput/password.show()
	$passwordInput.show()
	$loginSuccess.show()
	$send.show()
	
func hide():
	$login.hide()
	$newAccount.hide()
	$usernameInput/userName.hide()
	$passwordInput/password.hide()
	$passwordInput.hide()
	$loginSuccess.hide()
	$send.hide()
