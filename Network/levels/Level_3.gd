#Kirin Hardinger
#Created August 2022

#"1" refers to the bottom-most pipe
#"2" refers to the pipe coming out of the top of the watersource
#"3" refers to the pipe directly below pipe 4
#"4" refers to the top-most pipe

extends Node

#timer controls the speed that water tiles populate
var _timer = null

#keeps track of level complete conditions
var units_sent = 0
var units_required = 2

#initializes cost of each pipe
var cost_1 = 1
var cost_2 = 2
var cost_3 = 1
var cost_4 = 4

#x,y coordinates for water tilemaps
var x_1 = 6

var x_2 = 3
var y_2 = 8

var x_3 = 18
var y_3 = 6

var x_4 = 15
var y_4 = 3

#flags for whether or not the water has been sent down a route
var sent_1 = false
var sent_2 = false
var sent_3 = false

#flags for enable/disable button
var change_1 = false
var change_2 = false
var change_3 = false
var change_4 = false

#scene management
var main_scene
signal comp_3

#signal _complete

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
	#updates score label
	$Score.text = str(units_sent) + "/" + str(units_required)
	
	#updates cost labels
	$Cost/"1_cost".text = "Cost: " + str(cost_1)
	$Cost/"2_cost".text = "Cost: " + str(cost_2)
	$Cost/"3_cost".text = "Cost: " + str(cost_3)
	$Cost/"4_cost".text = "Cost: " + str(cost_4)
	
	#tooltps follow mouse
	$Tooltips/P1_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/P2_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/P3_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/P4_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/C_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/S_Panel.rect_global_position = get_viewport().get_mouse_position()
	
	#processes complete level
	if units_sent == units_required:
		#emit_signal("_complete")
		$HUD.scoreDisplay()
		disable_buttons()
		$Return.disabled = false
		$Return.show()
		$Message.text = "Level complete!"

#control functions for each route's water animations
func control_1():
	#begins water animation
	if !sent_1 and !sent_2 and !sent_3 and cost_1 < cost_2 + cost_3 and cost_1 < cost_2 + cost_4:
		if $Water/"1".get_cell(23, 10) == -1:
			disable_buttons()
			$Water/"1".set_cell(x_1, 10, $Water/"1".tile_set.find_tile_by_name("cap_1.tres 0"))
			x_1 = x_1 + 1
			change_1 = true
		else:
			if change_1:
				enable_buttons()
				$Shower/High.hide()
				$Shower/Low.show()
				$Shower/Soap.show()
				$Shower/Happy.hide()
				$Shower/Sad.show()
				sent_1 = true
				units_sent = 1
				x_1 = 6
			change_1 = false
	
	#reverses water animation
	if sent_1 and (cost_1 > cost_2 + cost_3 or cost_1 > cost_2 + cost_4):
		if $Water/"1".get_cell(23, 10) != -1:
			disable_buttons()
			$Water/"1".set_cell(x_1, 10, -1)
			x_1 = x_1 + 1
			change_1 = true
		else:
			if change_1:
				$Shower/High.hide()
				$Shower/Low.hide()
				$Shower/Soap.show()
				$Shower/Happy.hide()
				$Shower/Sad.show()
				sent_1 = false
				units_sent = 0
				x_1 = 6
			change_1 = false
			
func control_2():
	#begins water animation
	if !sent_2 and !sent_1 and (cost_2 + cost_3 < cost_1 or cost_2 + cost_4 < cost_1):
		if $Water/"2".get_cell(3, 7) == -1:
			disable_buttons()
			$Water/"2".set_cell(3, y_2, $Water/"2".tile_set.find_tile_by_name("full_cap_2.tres 1"))
			y_2 = y_2 - 1
		elif $Water/"2".get_cell(11, 6) == -1:
			disable_buttons()
			$Water/"2".set_cell(x_2, 6, $Water/"2".tile_set.find_tile_by_name("cap_2.tres 0"))
			x_2 = x_2 + 1
			change_2 = true
		else:
			if change_2:
				enable_buttons()
				sent_2 = true
				x_2 = 3
				y_2 = 8
			change_2 = false
			
	#reverses water animation
	if sent_2 and cost_1 < cost_2 + cost_3 and cost_1 < cost_2 + cost_4:
		if $Water/"2".get_cell(3, 7) != -1:
			disable_buttons()
			$Water/"2".set_cell(3, y_2, -1)
			y_2 = y_2 - 1
		elif $Water/"2".get_cell(11, 6) != -1:
			disable_buttons()
			$Water/"2".set_cell(x_2, 6, -1)
			x_2 = x_2 + 1
			change_2 = true
		else:
			if change_2:
				sent_2 = false
				x_2 = 3
				y_2 = 8
			change_2 = false
			
func control_3():
	#begins water animation
	if sent_2 and !sent_1 and cost_3 <= cost_4:
		if $Water/"3".get_cell(25, 5) == -1:
			disable_buttons()
			$Water/"3".set_cell(x_3, 5, $Water/"3".tile_set.find_tile_by_name("cap_1.tres 0"))
			x_3 = x_3 + 1
		elif $Water/"3".get_cell(25, 8) == -1:
			disable_buttons()
			$Water/"3".set_cell(25, y_3, $Water/"3".tile_set.find_tile_by_name("full_cap_1.tres 1"))
			y_3 = y_3 + 1
			change_3 = true
		else:
			if change_3:
				enable_buttons()
				$Shower/High.hide()
				$Shower/Low.show()
				$Shower/Soap.show()
				$Shower/Happy.hide()
				$Shower/Sad.show()
				sent_3 = true
				units_sent = 1
				x_3 = 18
				y_3 = 6
			change_3 = false
	
	#reverses water animation
	if sent_3 and (cost_4 < cost_3 or cost_1 < cost_2 + cost_3):
		if $Water/"3".get_cell(25, 5) != -1:
			disable_buttons()
			$Water/"3".set_cell(x_3, 5, -1)
			x_3 = x_3 + 1
		elif $Water/"3".get_cell(25, 8) != -1:
			disable_buttons()
			$Water/"3".set_cell(25, y_3, -1)
			y_3 = y_3 + 1
			change_3 = true
		else:
			if change_3:
				$Shower/High.hide()
				$Shower/Low.hide()
				$Shower/Soap.show()
				$Shower/Happy.hide()
				$Shower/Sad.show()
				sent_3 = false
				units_sent = 0
				x_3 = 18
				y_3 = 6
			change_3 = false

func control_4():
	#begins water animation
	if sent_2 and !sent_1 and !sent_3 and cost_4 < cost_3:
		if $Water/"4".get_cell(15, 3) == -1:
			disable_buttons()
			$Water/"4".set_cell(15, 3, $Water/"4".tile_set.find_tile_by_name("full_cap_2.tres 1"))
		elif $Water/"4".get_cell(28, 2) == -1:
			disable_buttons()
			$Water/"4".set_cell(x_4, 2, $Water/"4".tile_set.find_tile_by_name("cap_2.tres 0"))
			x_4 = x_4 + 1
		elif $Water/"4".get_cell(28, 8) == -1:
			disable_buttons()
			$Water/"4".set_cell(28, y_4, $Water/"4".tile_set.find_tile_by_name("full_cap_2.tres 1"))
			y_4 = y_4 + 1
			change_4 = true
		else:
			if change_4:
				enable_buttons()
				$Shower/High.show()
				$Shower/Low.hide()
				$Shower/Soap.hide()
				$Shower/Happy.show()
				$Shower/Sad.hide()
				units_sent = 2
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
#shower
func _on_S_Control_mouse_entered():
	$Tooltips/S_Panel.show()
	$Tooltips/S_Panel/Label.text = "Shower\n" + str(units_sent) + "/" + str(units_required) + " units\n\nReceives water from water source"

func _on_S_Control_mouse_exited():
	$Tooltips/S_Panel.hide()

#pipe 1
func _on_P1_Control_mouse_entered():
	$Tooltips/P1_Panel.show()
	$Tooltips/P1_Panel/Label.text = "Pipes\n\nCost: " + str(cost_1) + "\nCapacity: 1"

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
	$Tooltips/P3_Panel/Label.text = "Pipes\n\nCost: " + str(cost_3) + "\nCapacity: 1"

func _on_P3_Control_mouse_exited():
	$Tooltips/P3_Panel.hide()

#pipe 4
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
	
#exit
func _on_Return_pressed():
	main_scene._comp(3)
	self.queue_free()


func _on_Node_tree_entered():
	pass # Replace with function body.
