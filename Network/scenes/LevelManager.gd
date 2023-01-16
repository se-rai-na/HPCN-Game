#Kirin Hardinger
#Created July 2022

extends Node

#when true, allows playing any level without having to complete the previous one
var debug = false

#flags for respective level completion
#unlocks the next level
var flag_1 = false
var flag_2 = false
var flag_3 = false
var flag_4 = false
var flag_5 = false
var flag_6 = false
var flag_7 = false
var flag_8 = false
var flag_9 = false
var flag_10 = false

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
	hide_buttons()
	hide_checks()
	if not debug:
		$lvl2.disabled = true
		$lvl3.disabled = true
		$lvl4.disabled = true
		$lvl5.disabled = true
		$lvl6.disabled = true
		$lvl7.disabled = true
		$lvl8.disabled = true
		$lvl9.disabled = true
		$lvl10.disabled = true

func display():
	show_buttons()
	
	if flag_1:
		$CheckMark.show()
		$lvl2.disabled = false
	if flag_2:
		$CheckMark2.show()
		$lvl3.disabled = false
	if flag_3:
		$CheckMark3.show()
		$lvl4.disabled = false
	if flag_4:
		$CheckMark4.show()
		$lvl5.disabled = false
	if flag_5:
		$CheckMark5.show()
		$lvl6.disabled = false
	if flag_6:
		$CheckMark6.show()
		$lvl7.disabled = false
	if flag_7:
		$CheckMark7.show()
		$lvl8.disabled = false
	if flag_8:
		$CheckMark8.show()
		$lvl9.disabled = false
	if flag_9:
		$CheckMark9.show()
		$lvl10.disabled = false
	if flag_10:
		$CheckMark10.show()

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
			flag_1 = true
		2:
			flag_2 = true
		3:
			flag_3 = true
		4:
			flag_4 = true
		5:
			flag_5 = true
		6:
			flag_6 = true
		7:
			flag_7 = true
		8:
			flag_8 = true
		9:
			flag_9 = true
		10:
			flag_10 = true

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
