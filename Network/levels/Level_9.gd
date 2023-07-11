#Kirin Hardinger
#Created November 2022

#"1" refers to the pipe feeding into Shower2
#"2" refers to the pipe connecting pipe 1 and pipe 3
#"3" refers to the bottom-most pipe feeding into Shower3
#"4" refers to the red pipe
#"5" refers to the pipe feeding into Shower1
#"6" refers to the pipe connecting pipe 5 towards Shower2
#"7" refers to the top-most pipe feeding into Shower3

extends Node

#timer controls the speed that water tiles populate
var _timer = null

#keeps track of level complete conditions
var units_sent1 = 0
var units_sent2 = 0
var units_sent3 = 0
var units_required1 = 2
var units_required2 = 2
var units_required3 = 2

#initializes cost of each pipe
var cost_1 = 3
var cost_2 = 8
var cost_3 = 5
var cost_4 = 2
var cost_5 = 1
var cost_6 = 1
var cost_7 = 5

#x, y coordinates for water tilemaps
var x_1 = 6
var y_1 = 13

var x_2 = 12
var y_2 = 13

var x_3 = 18
var y_3 = 13

var x_4 = 15
var y_4 = 7

var x_5 = 12
var y_5 = 4

var x_6 = 9
var y_6 = 10

var x_7 = 18
var y_7 = 3

#flags for whether or not the water has been sent down a route
var sent_1 = false
var sent_2 = false
var sent_3 = false
var sent_4 = false
var sent_5 = false
var sent_6 = false
var sent_7 = false

#flags for enable/disable button
var change_1 = false
var change_2 = false
var change_3 = false
var change_4 = false
var change_5 = false
var change_6 = false
var change_7 = false

#scene management
var main_scene
signal comp_9
#highest possible score in the level
var maxScore = 80
#highest time at completion to still get the highest score
var minSecs = 70

func _ready():
	#sets main scene to return when level is done
	main_scene = get_node(get_parent().get_path())

	#this timer is used in water animation - how fast every tile is placed
	#it connects to each function that starts the water animation down a particular route
	_timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "control_1")
	_timer.connect("timeout", self, "control_2")
	_timer.connect("timeout", self, "control_3")
	_timer.connect("timeout", self, "control_4")
	_timer.connect("timeout", self, "control_5")
	_timer.connect("timeout", self, "control_6")
	_timer.connect("timeout", self, "control_7")
	_timer.set_wait_time(0.1)  
	_timer.start()

func _process(delta):
	#updates score labels
	$Shower1/Score.text = str(units_sent1) + "/" + str(units_required1)
	$Shower2/Score.text = str(units_sent2) + "/" + str(units_required2)
	$Shower3/Score.text = str(units_sent3) + "/" + str(units_required3)
	
	#updates cost labels
	$Cost/"1_cost".text = "Cost: " + str(cost_1)
	$Cost/"2_cost".text = "Cost: " + str(cost_2)
	$Cost/"3_cost".text = "Cost: " + str(cost_3)
	$Cost/"4_cost".text = "Cost: " + str(cost_4)
	$Cost/"5_cost".text = "Cost: " + str(cost_5)
	$Cost/"6_cost".text = "Cost: " + str(cost_6)
	$Cost/"7_cost".text = "Cost: " + str(cost_7)
	
	#tooltps follow mouse
	$Tooltips/S1_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/S2_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/S3_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/P1_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/P2_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/P3_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/P4_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/P5_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/P6_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/P7_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/C1_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/C2_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/C3_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/C4_Panel.rect_global_position = get_viewport().get_mouse_position()
	
	#processes complete level
	if units_sent1 == units_required1 and units_sent2 == units_required2 and units_sent3 == units_required3:
		$HUD.level = 9
		$HUD.scoreDisplay(maxScore, minSecs)
		disable_buttons()
		$Return.disabled = false
		$Return.show() 
		$Message.text = "Level complete!"

func control_1():
	#starts unsplit water animation
	if sent_2 and cost_4 + cost_7 < cost_3:
		if $Water/"1".get_cell(5, 13) != $Water/"1".tile_set.find_tile_by_name("cap_2.tres 0"):
			disable_buttons()
			$Water/"1".set_cell(x_1, 13, $Water/"1".tile_set.find_tile_by_name("cap_2.tres 0"))
			x_1 = x_1 - 1
		elif $Water/"1".get_cell(4, 12) != $Water/"1".tile_set.find_tile_by_name("full_cap_2.tres 1"):
			disable_buttons()
			$Water/"1".set_cell(4, y_1, $Water/"1".tile_set.find_tile_by_name("full_cap_2.tres 1"))
			y_1 = y_1 - 1
			change_1 = true
		else:
			if change_1:
				enable_buttons()
				$Shower2/High.show()
				$Shower2/Low.hide()
				$Shower2/Soap.hide()
				$Shower2/Happy.show()
				$Shower2/Sad.hide()
				sent_1 = true
				units_sent2 = 2
				x_1 = 6
				y_1 = 13
			change_1 = false
	
	#starts split water animation
	if (sent_2 and cost_4 + cost_7 > cost_3) or sent_6:
		if $Water/"1".get_cell(5, 13) != $Water/"1".tile_set.find_tile_by_name("cap_1.tres 2"):
			disable_buttons()
			$Water/"1".set_cell(x_1, 13, $Water/"1".tile_set.find_tile_by_name("cap_1.tres 2"))
			x_1 = x_1 - 1
		elif $Water/"1".get_cell(4, 13) != $Water/"1".tile_set.find_tile_by_name("3split.tres 3"):
			disable_buttons()
			$Water/"1".set_cell(4, 13, $Water/"1".tile_set.find_tile_by_name("3split.tres 3"))
		elif $Water/"1".get_cell(4, 12) != $Water/"1".tile_set.find_tile_by_name("split.tres 4"):
			disable_buttons()
			$Water/"1".set_cell(4, 12, $Water/"1".tile_set.find_tile_by_name("split.tres 4"))
			change_1 = true
		else:
			if change_1:
				enable_buttons()
				$Shower2/High.hide()
				$Shower2/Low.show()
				$Shower2/Soap.show()
				$Shower2/Happy.hide()
				$Shower2/Sad.show()
				sent_1 = true
				units_sent2 = 1
				x_1 = 6
				y_1 = 13
			change_1 = false
	
	#reverses water animation
	if sent_1 and not sent_6 and cost_4 + cost_5 + cost_6 < cost_2:
		if $Water/"1".get_cell(5, 13) != -1:
			disable_buttons()
			$Water/"1".set_cell(x_1, 13, -1)
			x_1 = x_1 - 1
		elif $Water/"1".get_cell(4, 12) != -1:
			disable_buttons()
			$Water/"1".set_cell(4, y_1, -1)
			y_1 = y_1 - 1
			change_1 = true
		else:
			if change_1:
				enable_buttons()
				$Shower2/High.hide()
				$Shower2/Low.hide()
				$Shower2/Soap.show()
				$Shower2/Happy.hide()
				$Shower2/Sad.show()
				sent_1 = false
				units_sent2 = 0
				x_1 = 6
				y_1 = 13
			change_1 = false

func control_2():
	#starts unsplit water animation
	if cost_2 < cost_4 + cost_5 + cost_6 and not sent_6 and cost_4 + cost_7 < cost_3:
		if $Water/"2".get_cell(x_2, y_2) != $Water/"2".tile_set.find_tile_by_name("cap_2.tres 0"):
			disable_buttons()
			$Water/"2".set_cell(x_2, y_2, $Water/"2".tile_set.find_tile_by_name("cap_2.tres 0"))
			change_2 = true
		else:
			if change_2:
				enable_buttons()
				sent_2 = true
				units_sent2 = 2
				x_2 = 12
				y_2 = 13
			change_2 = false
	
	#starts split water animation
	if cost_2 < cost_4 + cost_5 + cost_6 and not sent_6 and cost_4 + cost_7 > cost_3:
		if $Water/"2".get_cell(x_2, y_2) != $Water/"2".tile_set.find_tile_by_name("cap_1.tres 1"):
			disable_buttons()
			$Water/"2".set_cell(x_2, y_2, $Water/"2".tile_set.find_tile_by_name("cap_1.tres 1"))
			change_2 = true
		else:
			if change_2:
				enable_buttons()
				sent_2 = true
				units_sent2 = 1
				x_2 = 12
				y_2 = 13
			change_2 = false
	
	#reverses water animation
	if cost_2 > cost_4 + cost_5 + cost_6 and sent_2 and not sent_1:
		if $Water/"2".get_cell(x_2, y_2) != -1:
			disable_buttons()
			$Water/"2".set_cell(x_2, y_2, -1)
			change_2 = true
		else:
			if change_2:
				enable_buttons()
				sent_2 = false
				units_sent2 = 0
				x_2 = 12
				y_2 = 13
			change_2 = false

func control_3():
	#starts unsplit water animation
	if cost_4 + cost_5 + cost_6 < cost_2 and cost_4 + cost_7 > cost_3 and not sent_7:
		if $Water/"3".get_cell(25, 13) != $Water/"3".tile_set.find_tile_by_name("cap_2.tres 0"):
			disable_buttons()
			$Water/"3".set_cell(x_3, 13, $Water/"3".tile_set.find_tile_by_name("cap_2.tres 0"))
			x_3 = x_3 + 1
		elif $Water/"3".get_cell(26, 6) != $Water/"3".tile_set.find_tile_by_name("full_cap_2.tres 1"):
			disable_buttons()
			$Water/"3".set_cell(26, y_3, $Water/"3".tile_set.find_tile_by_name("full_cap_2.tres 1"))
			y_3 = y_3 - 1
			change_3 = true
		else:
			if change_3:
				enable_buttons()
				$Shower3/High.show()
				$Shower3/Low.hide()
				$Shower3/Soap.hide()
				$Shower3/Happy.show()
				$Shower3/Sad.hide()
				sent_3 = true
				units_sent3 = 2
				x_3 = 18
				y_3 = 13
			change_3 = false
	
	#starts split water animation
	if cost_4 + cost_5 + cost_6 > cost_2 and cost_4 + cost_7 > cost_3 and not sent_7:
		if $Water/"3".get_cell(25, 13) != $Water/"3".tile_set.find_tile_by_name("cap_1.tres 2"):
			disable_buttons()
			$Water/"3".set_cell(x_3, 13, $Water/"3".tile_set.find_tile_by_name("cap_1.tres 2"))
			x_3 = x_3 + 1
		elif $Water/"3".get_cell(26, 13) != $Water/"3".tile_set.find_tile_by_name("3split.tres 3"):
			disable_buttons()
			$Water/"3".set_cell(26, 13, $Water/"3".tile_set.find_tile_by_name("3split.tres 3"))
			y_3 = y_3 - 1
		elif $Water/"3".get_cell(26, 6) != $Water/"3".tile_set.find_tile_by_name("split.tres 4"):
			disable_buttons()
			$Water/"3".set_cell(26, y_3, $Water/"3".tile_set.find_tile_by_name("split.tres 4"))
			y_3 = y_3 - 1
			change_3 = true
		else:
			if change_3:
				enable_buttons()
				$Shower3/High.hide()
				$Shower3/Low.show()
				$Shower3/Soap.show()
				$Shower3/Happy.hide()
				$Shower3/Sad.show()
				sent_3 = true
				units_sent3 = 1
				x_3 = 18
				y_3 = 13
			change_3 = false
	
	#reverses water animation
	if cost_4 + cost_7 < cost_3 and sent_3:
		if $Water/"3".get_cell(25, 13) != -1:
			disable_buttons()
			$Water/"3".set_cell(x_3, 13, -1)
			x_3 = x_3 + 1
		elif $Water/"3".get_cell(26, 6) != -1:
			disable_buttons()
			$Water/"3".set_cell(26, y_3, -1)
			y_3 = y_3 - 1
			change_3 = true
		else:
			if change_3:
				enable_buttons()
				$Shower3/High.hide()
				$Shower3/Low.hide()
				$Shower3/Soap.show()
				$Shower3/Happy.hide()
				$Shower3/Sad.show()
				sent_3 = false
				units_sent3 = 0
				x_3 = 18
				y_3 = 13
			change_3 = false

func control_4():
	#starts water animation
	if $Water/"4".get_cell(15, 5) != $Water/"4".tile_set.find_tile_by_name("full_cap_2.tres 0"):
		disable_buttons()
		$Water/"4".set_cell(x_4, y_4, $Water/"4".tile_set.find_tile_by_name("full_cap_2.tres 0"))
		$Water/"4".set_cell(x_4 + 1, y_4, $Water/"4".tile_set.find_tile_by_name("split.tres 1"))
		y_4 = y_4 - 1
		change_4 = true
	else:
		if change_4:
			enable_buttons()
			sent_4 = true
			x_4 = 15
			y_4 = 7
		change_4 = false
			
	#no reversal/change function because pipe 4 will always be full
	
func control_5():
	#starts unsplit animation
	if cost_4 + cost_5 + cost_6 < cost_2 and sent_4:
		if $Water/"5".get_cell(10, 3) != $Water/"5".tile_set.find_tile_by_name("cap_1.tres 2"):
			disable_buttons()
			$Water/"5".set_cell(x_5, 3, $Water/"5".tile_set.find_tile_by_name("cap_1.tres 2"))
			x_5 = x_5 - 1
		elif $Water/"5".get_cell(9, 3) != $Water/"5".tile_set.find_tile_by_name("cap_1.tres 2"):
			disable_buttons()
			$Water/"5".set_cell(9, 3, $Water/"5".tile_set.find_tile_by_name("cap_1.tres 2"))
			$Water/"5".set_cell(9, 4, $Water/"5".tile_set.find_tile_by_name("full_cap_2.tres 1"))
			x_5 = x_5 - 1
		elif $Water/"5".get_cell(6, 3) != $Water/"5".tile_set.find_tile_by_name("cap_1.tres 2"):
			disable_buttons()
			$Water/"5".set_cell(x_5, 3, $Water/"5".tile_set.find_tile_by_name("cap_1.tres 2"))
			x_5 = x_5 - 1
			change_5 = true
		else:
			if change_5:
				enable_buttons()
				$Shower1/High.hide()
				$Shower1/Low.show()
				$Shower1/Soap.show()
				$Shower1/Happy.hide()
				$Shower1/Sad.show()
				sent_5 = true
				units_sent1 = 1
				x_5 = 12
				y_5 = 4
			change_5 = false
	
	#starts split water animation
	if cost_4 + cost_5 + cost_6 > cost_2 and sent_4:
		if $Water/"5".get_cell(10, 3) != $Water/"5".tile_set.find_tile_by_name("cap_2.tres 0"):
			disable_buttons()
			$Water/"5".set_cell(x_5, 3, $Water/"5".tile_set.find_tile_by_name("cap_2.tres 0"))
			x_5 = x_5 - 1
		elif $Water/"5".get_cell(9, 3) != $Water/"5".tile_set.find_tile_by_name("cap_2.tres 0"):
			disable_buttons()
			$Water/"5".set_cell(9, 3, $Water/"5".tile_set.find_tile_by_name("cap_2.tres 0"))
			$Water/"5".set_cell(9, 4, $Water/"5".tile_set.find_tile_by_name("full_cap_2.tres 1"))
			x_5 = x_5 - 1
		elif $Water/"5".get_cell(6, 3) != $Water/"5".tile_set.find_tile_by_name("cap_2.tres 0"):
			disable_buttons()
			$Water/"5".set_cell(x_5, 3, $Water/"5".tile_set.find_tile_by_name("cap_2.tres 0"))
			x_5 = x_5 - 1
			change_5 = true
		else:
			if change_5:
				enable_buttons()
				$Shower1/High.show()
				$Shower1/Low.hide()
				$Shower1/Soap.hide()
				$Shower1/Happy.show()
				$Shower1/Sad.hide()
				sent_5 = true
				units_sent1 = 2
				x_5 = 12
				y_5 = 4
			change_5 = false
	
	#no reversal function because pipe 5 will always have some amount of water
	
func control_6():
	#starts water animation
	if not sent_2 and cost_4 + cost_5 + cost_6 < cost_2 and $Water/"5".get_cell(9, 4) == $Water/"5".tile_set.find_tile_by_name("full_cap_2.tres 1"):
		if $Water/"6".get_cell(9, 10) != $Water/"6".tile_set.find_tile_by_name("split.tres 0"):
			disable_buttons()
			$Water/"6".set_cell(x_6, y_6, $Water/"6".tile_set.find_tile_by_name("split.tres 0"))
			change_6 = true
		else:
			if change_6:
				sent_6 = true
			change_6 = false
	
	#reverses water animation
	if cost_4 + cost_5 + cost_6 > cost_2 and sent_5:
		if $Water/"6".get_cell(9, 10) != -1:
			disable_buttons()
			$Water/"6".set_cell(x_6, y_6, -1)
			change_6 = true
		else:
			if change_6:
				sent_6 = false
			change_6 = false
	
func control_7():
	#starts water animation
	if cost_4 + cost_7 < cost_3 and sent_4 and not sent_3:
		if $Water/"7".get_cell(23, 3) != $Water/"7".tile_set.find_tile_by_name("cap_2.tres 0"):
			disable_buttons()
			$Water/"7".set_cell(x_7, y_7, $Water/"7".tile_set.find_tile_by_name("cap_2.tres 0"))
			x_7 = x_7 + 1
			change_7 = true
		else:
			if change_7:
				enable_buttons()
				$Shower3/High.show()
				$Shower3/Low.hide()
				$Shower3/Soap.hide()
				$Shower3/Happy.show()
				$Shower3/Sad.hide()
				sent_7 = true
				units_sent3 = 2
				x_7 = 18
				y_7 = 3
			change_7 = false
	
	#reverses water animation
	if cost_4 + cost_7 > cost_3 and sent_4:
		if $Water/"7".get_cell(23, 3) != -1:
			disable_buttons()
			$Water/"7".set_cell(x_7, y_7, -1)
			x_7 = x_7 + 1
			change_7 = true
		else:
			if change_7:
				enable_buttons()
				$Shower3/High.hide()
				$Shower3/Low.hide()
				$Shower3/Soap.show()
				$Shower3/Happy.hide()
				$Shower3/Sad.show()
				sent_7 = false
				units_sent3 = 0
				x_7 = 18
				y_7 = 3
			change_7 = false

#enable/disable the +/- buttons
#prevents users from changing the cost in the middle of the water animations
func enable_buttons():
	$Cost/"1_plus".disabled = false
	$Cost/"1_minus".disabled = false
	$Cost/"2_plus".disabled = false
	$Cost/"2_minus".disabled = false
	$Cost/"3_plus".disabled = false
	$Cost/"3_minus".disabled = false
	$Cost/"4_plus".disabled = false 
	$Cost/"4_minus".disabled = false
	$Cost/"5_plus".disabled = false
	$Cost/"5_minus".disabled = false
	$Cost/"6_plus".disabled = false
	$Cost/"6_minus".disabled = false
	$Cost/"7_plus".disabled = false 
	$Cost/"7_minus".disabled = false

func disable_buttons():
	$Cost/"1_plus".disabled = true
	$Cost/"1_minus".disabled = true
	$Cost/"2_plus".disabled = true
	$Cost/"2_minus".disabled = true
	$Cost/"3_plus".disabled = true
	$Cost/"3_minus".disabled = true
	$Cost/"4_plus".disabled = true
	$Cost/"4_minus".disabled = true
	$Cost/"5_plus".disabled = true
	$Cost/"5_minus".disabled = true
	$Cost/"6_plus".disabled = true
	$Cost/"6_minus".disabled = true
	$Cost/"7_plus".disabled = true
	$Cost/"7_minus".disabled = true

#connects to the +/- buttons and increases/decreases the cost of a pipe
func _on_1_plus_pressed():
	if cost_1 < 10:
		cost_1 = cost_1 + 1

func _on_1_minus_pressed():
	if cost_1 != 1:
		cost_1 = cost_1 - 1

func _on_2_plus_pressed():
	if cost_2 < 10:
		cost_2 = cost_2 + 1

func _on_2_minus_pressed():	
	if cost_2 != 1:
		cost_2 = cost_2 - 1

func _on_3_plus_pressed():
	if cost_3 < 10:
		cost_3 = cost_3 + 1

func _on_3_minus_pressed():
	if cost_3 != 1:
		cost_3 = cost_3 - 1

func _on_4_plus_pressed():
	if cost_4 < 10:
		cost_4 = cost_4 + 1

func _on_4_minus_pressed():
	if cost_4 != 1:
		cost_4 = cost_4 - 1
		
func _on_5_plus_pressed():
	if cost_5 < 10:
		cost_5 = cost_5 + 1

func _on_5_minus_pressed():
	if cost_5 != 1:
		cost_5 = cost_5 - 1
		
func _on_6_plus_pressed():
	if cost_6 < 10:
		cost_6 = cost_6 + 1

func _on_6_minus_pressed():
	if cost_6 != 1:
		cost_6 = cost_6 - 1
		
func _on_7_plus_pressed():
	if cost_7 < 10:
		cost_7 = cost_7 + 1

func _on_7_minus_pressed():
	if cost_7 != 1:
		cost_7 = cost_7 - 1
		
#tooltips control
#shower 1
func _on_S1_Control_mouse_entered():
	$Tooltips/S1_Panel.show()
	$Tooltips/S1_Panel/Label.text = "Shower\n" + str(units_sent1) + "/" + str(units_required1) + " units\n\nReceives water from water source"

func _on_S1_Control_mouse_exited():
	$Tooltips/S1_Panel.hide()

#shower 2
func _on_S2_Control_mouse_entered():
	$Tooltips/S2_Panel.show()
	$Tooltips/S2_Panel/Label.text = "Shower\n" + str(units_sent2) + "/" + str(units_required2) + " units\n\nReceives water from water source"

func _on_S2_Control_mouse_exited():
	$Tooltips/S2_Panel.hide()
	
#shower 3
func _on_S3_Control_mouse_entered():
	$Tooltips/S3_Panel.show()
	$Tooltips/S3_Panel/Label.text = "Shower\n" + str(units_sent3) + "/" + str(units_required3) + " units\n\nReceives water from water source"

func _on_S3_Control_mouse_exited():
	$Tooltips/S3_Panel.hide()
	
#pipes
#pipes 1
func _on_P1_Control_mouse_entered():
	$Tooltips/P1_Panel.show()
	$Tooltips/P1_Panel/Label.text = "Pipes\n\nCost: " + str(cost_1) + "\nCapacity: 2"

func _on_P1_Control_mouse_exited():
	$Tooltips/P1_Panel.hide()

#pipes 2
func _on_P2_Control_mouse_entered():
	$Tooltips/P2_Panel.show()
	$Tooltips/P2_Panel/Label.text = "Pipes\n\nCost: " + str(cost_2) + "\nCapacity: 2"

func _on_P2_Control_mouse_exited():
	$Tooltips/P2_Panel.hide()

#pipes 3
func _on_P3_Control_mouse_entered():
	$Tooltips/P3_Panel.show()
	$Tooltips/P3_Panel/Label.text = "Pipes\n\nCost: " + str(cost_3) + "\nCapacity: 2"

func _on_P3_Control_mouse_exited():
	$Tooltips/P3_Panel.hide()

#pipes 4
func _on_P4_Control_mouse_entered():
	$Tooltips/P4_Panel.show()
	$Tooltips/P4_Panel/Label.text = "Pipes\n\nCost: " + str(cost_4) + "\nCapacity: 4"

func _on_P4_Control_mouse_exited():
	$Tooltips/P4_Panel.hide()

#pipes 5
func _on_P5_Control_mouse_entered():
	$Tooltips/P5_Panel.show()
	$Tooltips/P5_Panel/Label.text = "Pipes\n\nCost: " + str(cost_5) + "\nCapacity: 2"

func _on_P5_Control_mouse_exited():
	$Tooltips/P5_Panel.hide()

#pipes 6
func _on_P6_Control_mouse_entered():
	$Tooltips/P6_Panel.show()
	$Tooltips/P6_Panel/Label.text = "Pipes\n\nCost: " + str(cost_6) + "\nCapacity: 2"

func _on_P6_Control_mouse_exited():
	$Tooltips/P6_Panel.hide()
	
#pipes 7
func _on_P7_Control_mouse_entered():
	$Tooltips/P7_Panel.show()
	$Tooltips/P7_Panel/Label.text = "Pipes\n\nCost: " + str(cost_7) + "\nCapacity: 2"

func _on_P7_Control_mouse_exited():
	$Tooltips/P7_Panel.hide()
	
#connector 1
func _on_C1_Control_mouse_entered():
	$Tooltips/C1_Panel.show()

func _on_C1_Control_mouse_exited():
	$Tooltips/C1_Panel.hide()
	
#connector 2
func _on_C2_Control_mouse_entered():
	$Tooltips/C2_Panel.show()

func _on_C2_Control_mouse_exited():
	$Tooltips/C2_Panel.hide()
	
#connector 3
func _on_C3_Control_mouse_entered():
	$Tooltips/C3_Panel.show()

func _on_C3_Control_mouse_exited():
	$Tooltips/C3_Panel.hide()
	
#connector 4
func _on_C4_Control_mouse_entered():
	$Tooltips/C4_Panel.show()

func _on_C4_Control_mouse_exited():
	$Tooltips/C4_Panel.hide()

func _on_Return_pressed():
	main_scene._comp(9)
	self.queue_free()
