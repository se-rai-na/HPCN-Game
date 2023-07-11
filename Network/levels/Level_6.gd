#Kirin Hardinger
#Created September 2022

#"1" refers to the top-most red pipe
#"2" refers to the bottom-most red pipe
#"3" refers to the pipe coming out of the right of the watersource
#"4" refers to the pipe coming out of the bottom of the watersource

extends Node

#timer controls the speed that water tiles populate
var _timer = null

#keeps track of level complete conditions
var units_sent1 = 0
var units_sent2 = 0
var units_required1 = 2
var units_required2 = 2

#initializes cost of each pipe
var cost_1 = 5
var cost_2 = 3
var cost_3 = 4
var cost_4 = 3

#x, y coordinates for water tilemaps
var x_1 = 2
var y_1 = 4

var x_2 = 21
var y_2 = 12

var x_3 = 5
var y_3 = 8

var x_4 = 3
var y_4 = 11

#flags for whether or not the water has been sent down a route
var sent_1 = false
var sent_2 = false
var sent_3 = false
var sent_4 = false

#flags for enable/disable button
var change_1 = false
var change_2 = false
var change_3 = false
var change_4 = false

#scene management
var main_scene
signal comp_6
#highest possible score in the level
var maxScore = 65
#highest time at completion to still get the highest score
var minSecs = 60

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
	$Cost/"4_cost".text = "Cost: " + str(cost_4)
	
	#tooltps follow mouse
	$Tooltips/S1_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/S2_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/P1_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/P2_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/P3_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/P4_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/C_Panel.rect_global_position = get_viewport().get_mouse_position()
	
	#processes complete level
	if units_sent1 == units_required1 and units_sent2 == units_required2:
		$HUD.level = 6
		$HUD.scoreDisplay(maxScore, minSecs)
		disable_buttons()
		$Return.disabled = false
		$Return.show()
		$Message.text = "Level complete!"

func control_1():
	if cost_1 + cost_2 < cost_3 and cost_1 + cost_2 < cost_4 and !sent_3 and !sent_4:
		if $Water/"1".get_cell(2, 3) == -1:
			disable_buttons()
			$Water/"1".set_cell(2, y_1, $Water/"1".tile_set.find_tile_by_name("full_cap_2.tres 0"))
			$Water/"1".set_cell(3, y_1, $Water/"1".tile_set.find_tile_by_name("split.tres 3"))			
			y_1 = y_1 - 1
		elif $Water/"1".get_cell(21, 2) == -1:
			disable_buttons()
			$Water/"1".set_cell(x_1, 2, $Water/"1".tile_set.find_tile_by_name("full_cap_2.tres 0"))
			$Water/"1".set_cell(x_1, 1, $Water/"1".tile_set.find_tile_by_name("cap_1.tres 2"))
			x_1 = x_1 + 1
			y_1 = 3
		elif $Water/"1".get_cell(22, 6) == -1:
			disable_buttons()
			$Water/"1".set_cell(22, y_1, $Water/"1".tile_set.find_tile_by_name("full_cap_2.tres 0"))
			y_1 = y_1 + 1
			if $Water/"1".get_cell(24, 2) == -1:
				$Water/"1".set_cell(x_1, 2, $Water/"1".tile_set.find_tile_by_name("cap_2.tres 1"))
				x_1 = x_1 + 1
			change_1 = true
		else:
			if change_1:
				enable_buttons()
				$Shower1/High.show()
				$Shower1/Low.hide()
				$Shower1/Soap.hide()
				$Shower1/Happy.show()
				$Shower1/Sad.hide()
				sent_1 = true
				units_sent1 = 2
				x_1 = 2
				y_1 = 4
			change_1 = false
	
func control_2():
	if sent_1:
		if $Water/"2".get_cell(22, 14) == -1:
			disable_buttons()
			$Water/"2".set_cell(22, y_2, $Water/"2".tile_set.find_tile_by_name("full_cap_2.tres 0"))
			y_2 = y_2 + 1
		elif $Water/"2".get_cell(15, 14) == -1:
			disable_buttons()
			$Water/"2".set_cell(x_2, 14, $Water/"2".tile_set.find_tile_by_name("cap_2.tres 1"))
			x_2 = x_2 - 1
			change_2 = true
		else:
			if change_2:
				enable_buttons()
				$Shower2/High.show()
				$Shower2/Low.hide()
				$Shower2/Soap.hide()
				$Shower2/Happy.show()
				$Shower2/Sad.hide()
				sent_2 = true
				units_sent2= 2
				x_2 = 21
				y_2 = 12
			change_2 = false

func control_3():
	#sends water
	if cost_1 + cost_2 > cost_3 and cost_3 < cost_4 and !sent_1 and !sent_4:
		if $Water/"3".get_cell(12, 7) == -1:
			disable_buttons()
			$Water/"3".set_cell(x_3, 7, $Water/"3".tile_set.find_tile_by_name("cap_1.tres 1"))
			x_3 = x_3 + 1
		elif $Water/"3".get_cell(12, 11) == -1:
			disable_buttons()
			$Water/"3".set_cell(12, y_3, $Water/"3".tile_set.find_tile_by_name("full_cap_1.tres 0"))
			y_3 = y_3 + 1
			change_3 = true
		else:
			if change_3:
				enable_buttons()
				$Shower2/High.hide()
				$Shower2/Low.show()
				$Shower2/Soap.show()
				$Shower2/Happy.hide()
				$Shower2/Sad.show()
				sent_3 = true
				units_sent2 = 1
				x_3 = 5
				y_3 = 8
			change_3 = false
	
	#reverses water
	if sent_3 and (cost_1 + cost_2 < cost_3 or cost_4 < cost_3):
		if $Water/"3".get_cell(12, 7) != -1:
			disable_buttons()
			$Water/"3".set_cell(x_3, 7, -1)
			x_3 = x_3 + 1
		elif $Water/"3".get_cell(12, 11) != -1:
			disable_buttons()
			$Water/"3".set_cell(12, y_3, -1)
			y_3 = y_3 + 1
			change_3 = true
		else:
			if change_3:
				enable_buttons()
				$Shower2/High.hide()
				$Shower2/Low.hide()
				$Shower2/Soap.show()
				$Shower2/Happy.hide()
				$Shower2/Sad.show()
				sent_3 = false
				units_sent2 = 0
				x_3 = 5
				y_3 = 8
			change_3 = false
	
func control_4():
	#sends water
	if cost_1 + cost_2 > cost_4 and cost_4 < cost_3 and !sent_1 and !sent_3:
		if $Water/"4".get_cell(2, 14) == -1:
			disable_buttons()
			$Water/"4".set_cell(2, y_4, $Water/"4".tile_set.find_tile_by_name("full_cap_2.tres 0"))
			y_4 = y_4 + 1
		elif $Water/"4".get_cell(9, 14) == -1:
			disable_buttons()
			$Water/"4".set_cell(x_4, 14, $Water/"4".tile_set.find_tile_by_name("cap_2.tres 1"))
			x_4 = x_4 + 1
			change_4 = true
		else:
			if change_4:
				enable_buttons()
				$Shower2/High.show()
				$Shower2/Low.hide()
				$Shower2/Soap.hide()
				$Shower2/Happy.show()
				$Shower2/Sad.hide()
				sent_4 = true
				units_sent2 = 2
				x_4 = 3
				y_4 = 11
			change_4 = false
	
	#reverses water
	if (cost_1 + cost_2 < cost_4 or cost_3 < cost_4) and sent_4:
		if $Water/"4".get_cell(2, 14) != -1:
			disable_buttons()
			$Water/"4".set_cell(2, y_4, -1)
			y_4 = y_4 + 1
		elif $Water/"4".get_cell(9, 14) != -1:
			disable_buttons()
			$Water/"4".set_cell(x_4, 14, -1)
			x_4 = x_4 + 1
			change_4 = true
		else:
			if change_4:
				enable_buttons()
				$Shower2/High.hide()
				$Shower2/Low.hide()
				$Shower2/Soap.show()
				$Shower2/Happy.hide()
				$Shower2/Sad.show()
				sent_4 = false
				units_sent2 = 0
				x_4 = 3
				y_4 = 11
			change_4 = false
	
func enable_buttons():
	$Cost/"1_plus".disabled = false
	$Cost/"1_minus".disabled = false
	$Cost/"2_plus".disabled = false
	$Cost/"2_minus".disabled = false
	$Cost/"3_plus".disabled = false
	$Cost/"3_minus".disabled = false
	$Cost/"4_plus".disabled = false 
	$Cost/"4_minus".disabled = false

func disable_buttons():
	$Cost/"1_plus".disabled = true
	$Cost/"1_minus".disabled = true
	$Cost/"2_plus".disabled = true
	$Cost/"2_minus".disabled = true
	$Cost/"3_plus".disabled = true
	$Cost/"3_minus".disabled = true
	$Cost/"4_plus".disabled = true
	$Cost/"4_minus".disabled = true

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

#tooltip controls
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
#pipes 1
func _on_P1_Control_mouse_entered():
	$Tooltips/P1_Panel.show()
	$Tooltips/P1_Panel/Label.text = "Pipes\n\nCost: " + str(cost_1) + "\nCapacity: 4"

func _on_P1_Control_mouse_exited():
	$Tooltips/P1_Panel.hide()

#pipes 2
func _on_P2_Control_mouse_entered():
	$Tooltips/P2_Panel.show()
	$Tooltips/P2_Panel/Label.text = "Pipes\n\nCost: " + str(cost_2) + "\nCapacity: 4"

func _on_P2_Control_mouse_exited():
	$Tooltips/P2_Panel.hide()

#pipes 3
func _on_P3_Control_mouse_entered():
	$Tooltips/P3_Panel.show()
	$Tooltips/P3_Panel/Label.text = "Pipes\n\nCost: " + str(cost_3) + "\nCapacity: 1"

func _on_P3_Control_mouse_exited():
	$Tooltips/P3_Panel.hide()

#pipes 4
func _on_P4_Control_mouse_entered():
	$Tooltips/P4_Panel.show()
	$Tooltips/P4_Panel/Label.text = "Pipes\n\nCost: " + str(cost_4) + "\nCapacity: 2"

func _on_P4_Control_mouse_exited():
	$Tooltips/P4_Panel.hide()
	
#connector
func _on_C_Control_mouse_entered():
	$Tooltips/C_Panel.show()

func _on_C_Control_mouse_exited():
	$Tooltips/C_Panel.hide()

func _on_Return_pressed():
	main_scene._comp(6)
	self.queue_free()
