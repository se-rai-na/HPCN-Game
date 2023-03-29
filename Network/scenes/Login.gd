extends Node

# Declare variables for our two line edit nodes
var usernameInput
var passwordInput

func _ready():
	print("Scen started")
		
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
	# Get the current input from the line edit node that emitted the signal
	#if _lineEdit != null:
	#	_input = _lineEdit.text
	#else:
	#	_input = usernameInput
	#	print("LineEdit is null")
	#	return

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
	usernameInput = get_node("usernameInput")
	passwordInput = get_node("passwordInput")
	usernameInput = $usernameInput.get_text()
	passwordInput = $passwordInput.get_text()
	print(usernameInput)
	print(passwordInput)
	# Connect the line edit nodes to our function that will check their input
	#usernameInput.connect("text_entered", self, "check_login")
	#passwordInput.connect("text_entered", self, "check_login")
	check_login()


func _on_newAccount_pressed():
	add_child(load("res://scenes/Register.tscn").instance())
