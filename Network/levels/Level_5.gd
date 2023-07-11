#Kirin Hardinger
#Created October 2022

#"1" refers to the red pipe
#"2" refers to the pipe coming out of the right of the watersource
#"3" refers to the pipe directly below pipe 4
#"4" refers to the top-most pipe

extends Node

#timer controls the speed that water tiles populate
var _timer = null

#keeps track of level complete conditions
var units_sent1 = 0
var units_sent2 = 0
var units_required1 = 4
var units_required2 = 2

#initializes cost of each pipe
var cost_1 = 2
var cost_2 = 2
var cost_3 = 6

#x, y coordinates for water tilemaps
var x_1 = 12
var y_1 = 3

var x_2 = 18
var y_2 = 3

var x_3 = 11

var y_4 = 8

#flags for whether or not the water has been sent down a route
var sent_1 = false
var sent_2 = false
var sent_3 = false
var sent_4 = false
var initial = true

#flags for enable/disable button
var change_1 = false
var change_2 = false
var change_3 = false
var change_4 = false

#scene management
var main_scene
signal comp_5
#highest possible score in the level
var maxScore = 60
#highest time at completion to still get the highest score
var minSecs = 50

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
	_timer.set_wait_time(0.1)  
	_timer.start()
	
func _process(delta):
	#updates score labels
	$Shower1/Score.text = str(units_sent1) + "/" + str(units_required1)
	$Shower2/Score.text = str(units_sent2) + "/" + str(units_required2)
	
	#updates cost labels
	$Cost/"1_cost".text = "Cost: " + str(cost_1)
	$Cost/"2_cost".text = "Cost: " + str(cost_2)
	$Cost/"3_cost".text = "Cost: " + str(cost_3)
	
	#tooltps follow mouse
	$Tooltips/P1_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/P2_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/P3_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/S1_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/S2_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/C_Panel.rect_global_position = get_viewport().get_mouse_position()
	
	
	#processes complete level
	if  units_sent1 == units_required1 and units_sent2 == units_required2:
		$HUD.level = 5
		$HUD.scoreDisplay(maxScore, minSecs)
		disable_buttons()
		$Return.disabled = false
		$Return.show()
		$Message.text = "Level complete!"
	
func control_1():
	#begins water animation
	if initial:
		if $Water/"1".get_cell(5, 2) == -1:
			disable_buttons()
			$Water/"1".set_cell(x_1, 2, $Water/"1".tile_set.find_tile_by_name("cap_1.tres 3"))
			x_1 = x_1 - 1
		elif $Water/"1".get_cell(4, 2) == -1:
			disable_buttons()
			$Water/"1".set_cell(x_1, 2, $Water/"1".tile_set.find_tile_by_name("splitoff_right.tres 5"))
			x_1 = x_1 - 1
		elif $Water/"1".get_cell(4, 7) == -1:
			disable_buttons()
			$Water/"1".set_cell(4, y_1, $Water/"1".tile_set.find_tile_by_name("split_right.tres 4"))
			y_1 = y_1 + 1
			change_1 = true
		else:
			if change_1:
				enable_buttons()
				$Shower1/High.hide()
				$Shower1/Low.show()
				$Shower1/Soap.show()
				$Shower1/Happy.hide()
				$Shower1/Sad.show()
				sent_1 = true
				initial = false
				units_sent1 = 1
				x_1 = 12
				y_1 = 3
			change_1 = false
	
	#reverses water animation
	if sent_1 and cost_1 > cost_3:
		if $Water/"1".get_cell(4, 2) != -1:
			disable_buttons()
			$Water/"1".set_cell(x_1, 2, -1)
			x_1 = x_1 - 1
		elif $Water/"1".get_cell(4, 7) != -1:
			disable_buttons()
			$Water/"1".set_cell(4, y_1, -1)
			y_1 = y_1 + 1
			change_1 = true
		else:
			if change_1:
				$Shower1/High.hide()
				$Shower1/Low.hide()
				$Shower1/Soap.show()
				$Shower1/Happy.hide()
				$Shower1/Sad.show()
				sent_1 = false
				initial = false
				units_sent1 = 1
				x_1 = 12
				y_1 = 3
			change_1 = false

func control_2():
	if initial:
		if $Water/"2".get_cell(24, 2) == -1:
			disable_buttons()
			$Water/"2".set_cell(x_2, 2, $Water/"2".tile_set.find_tile_by_name("cap_1.tres 3"))
			x_2 = x_2 + 1
		elif $Water/"2".get_cell(25, 2) == -1:
			disable_buttons()
			$Water/"2".set_cell(x_2, 2, $Water/"2".tile_set.find_tile_by_name("splitoff.tres 4"))
			x_2 = x_2 + 1
		elif $Water/"2".get_cell(25, 7) == -1:
			disable_buttons()
			$Water/"2".set_cell(25, y_2, $Water/"2".tile_set.find_tile_by_name("split.tres 0"))
			y_2 = y_2 + 1
			change_2 = true
		else:
			if change_2:
				enable_buttons()
				$Shower2/High.hide()
				$Shower2/Low.show()
				$Shower2/Soap.show()
				$Shower2/Happy.hide()
				$Shower2/Sad.show()
				sent_2 = true
				units_sent2 = 1
				x_2 = 18
				y_2 = 3
			change_2 = false
	
	if sent_2 and cost_3 < cost_1:
		if $Water/"2".get_cell(25, 2) != $Water/"2".tile_set.find_tile_by_name("cap_2.tres 1"):
			disable_buttons()
			$Water/"2".set_cell(x_2, 2, $Water/"2".tile_set.find_tile_by_name("cap_2.tres 1"))
			x_2 = x_2 + 1
		elif $Water/"2".get_cell(25, 7) != $Water/"2".tile_set.find_tile_by_name("full_cap_2.tres 2"):
			disable_buttons()
			$Water/"2".set_cell(25, y_2, $Water/"2".tile_set.find_tile_by_name("full_cap_2.tres 2"))
			y_2 = y_2 + 1
			change_2 = true
		else:
			if change_2:
				$Shower2/High.show()
				$Shower2/Low.hide()
				$Shower2/Soap.hide()
				$Shower2/Happy.show()
				$Shower2/Sad.hide()
				sent_2 = true
				units_sent2 = 2
				x_2 = 18
				y_2 = 3
			change_2 = false

func control_3():
	if cost_3 < cost_1 and not sent_3 and not sent_1:
		if $Water/"3".get_cell(7, 10) == -1:
			disable_buttons()
			$Water/"3".set_cell(x_3, 10, $Water/"3".tile_set.find_tile_by_name("full_cap_2.tres 0"))
			$Water/"3".set_cell(x_3, 9, $Water/"3".tile_set.find_tile_by_name("cap_1.tres 1"))			
			x_3 = x_3 - 1
			change_3 = true
		else:
			if change_3:
				enable_buttons()
				$Shower1/High.show()
				$Shower1/Low.hide()
				$Shower1/Soap.hide()
				$Shower1/Happy.show()
				$Shower1/Sad.hide()
				sent_3 = true
				units_sent1 = 4
				x_3 = 11
			change_3 = false
			
func control_4():
	if $Water/"4".get_cell(15, 4) == -1:
		disable_buttons()
		$Water/"4".set_cell(15, y_4, $Water/"4".tile_set.find_tile_by_name("full_cap_2.tres 0"))
		y_4 = y_4 - 1
		change_4 = true
	else:
		if change_4:
			sent_4 = true
			y_4 = 8
		change_4 = false

#enable/disable the +/- buttons
#prevents users from changing the cost in the middle of the water animations
func enable_buttons():
	$Cost/"1_plus".disabled = false
	$Cost/"1_minus".disabled = false
	$Cost/"2_plus".disabled = false
	$Cost/"2_minus".disabled = false
	$Cost/"3_plus".disabled = false
	$Cost/"3_minus".disabled = false

func disable_buttons():
	$Cost/"1_plus".disabled = true
	$Cost/"1_minus".disabled = true
	$Cost/"2_plus".disabled = true
	$Cost/"2_minus".disabled = true
	$Cost/"3_plus".disabled = true
	$Cost/"3_minus".disabled = true
	
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

#tooltip controls
#hint
func _on_Button_Hint_pressed():
	$H_Control.hide()
	$H_Control/Button_Hint.disabled = true

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
	
#pipes
#pipe 1
func _on_P1_Control_mouse_entered():
	$Tooltips/P1_Panel.show()
	$Tooltips/P1_Panel/Label.text = "Pipes\n\nCost: " + str(cost_1) + "\nCapacity: 2"

func _on_P1_Control_mouse_exited():
	$Tooltips/P1_Panel.hide()

#pipe 2
func _on_P2_Control_mouse_entered():
	$Tooltips/P2_Panel.show()
	$Tooltips/P2_Panel/Label.text = "Pipes\n\nCost: " + str(cost_2) + "\nCapacity: 2"

func _on_P2_Control_mouse_exited():
	$Tooltips/P2_Panel.hide()

#pipe 3
func _on_P3_Control_mouse_entered():
	$Tooltips/P3_Panel.show()
	$Tooltips/P3_Panel/Label.text = "Pipes\n\nCost: " + str(cost_3) + "\nCapacity: 4"

func _on_P3_Control_mouse_exited():
	$Tooltips/P3_Panel.hide()

#connector
func _on_C_Control_mouse_entered():
	$Tooltips/C_Panel.show()

func _on_C_Control_mouse_exited():
	$Tooltips/C_Panel.hide()

#exit
func _on_Return_pressed():
	main_scene._comp(5)
	self.queue_free()

