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
		print("USERNAME")
		check_username()
	else:
		print("WROOOONG")
		$message.text = "Passwords must match!"
		return
	
func check_username():
	print("check username")
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

func _on_Button_pressed():
	print("BUTTON PRESSED")
	usernameInput = $userNameInput.get_text()
	passwordInput = $passwordInput.get_text()
	pwdInput = $passwordAgainInput.get_text()
	check_password()
	
	
