#Kirin Hardinger
#Created July 2022

#"1" refers to top pipe/water system, "2" refers to bottom pipe/water system

extends Node

signal level_success

#timer controls the speed that water tiles populate
var _timer = null

#timer is used to update the timer display on screen
var timer = 0

#initializes cost of each pipe
var top_cost = 2
var bottom_cost = 1

#x,y coordinates for water tilemaps
var top_x = 3

var bottom_x = 6

#flags for whether or not the water has been sent down a route
var sent_top = false
var sent_bottom = false

#flags for enable/disable button
var change_1 = false
var change_2 = false

#keeps track of level complete conditions
var units_sent = 0
var units_required = 2

#to calculate the score
var clicks = 0
var score = 0

#scene management
var main_scene
signal comp_2

func _ready():
	#sets main scene to return when level is done
	main_scene = get_node(get_parent().get_path())
	
	#this timer is used in water animation - how fast every tile is placed
	#it connects to each function that starts the water animation down a particular route
	_timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "control_bottom")
	_timer.connect("timeout", self, "control_top")
	_timer.set_wait_time(0.1) #this number is changed to adjust the speed
	_timer.start()
	
func _process(delta):
	#updates score and costs of routes
	$Score.text = str(units_sent) + "/" + str(units_required)
	$Cost/Top_cost.text = "Cost: " + str(top_cost)
	$Cost/Bottom_cost.text = "Cost: " + str(bottom_cost)
	
	#updates the timer
	
	timer = timer + delta
	$timer_display.text = "Time: " + str(round(timer)) + "s."
	
	#tooltps follow mouse
	$Tooltips/P1_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/P2_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/S_Panel.rect_global_position = get_viewport().get_mouse_position()
	
	#processes level completion
	if units_sent == units_required:
		#call function to display score
		showResults()
		#remove process function from scene tree
		set_process(false)

#calculates the score for a level
#best case: only needed 2 clicks = 5 points
#each additional pair of clicks leads to 1 point subtracted
func calculateScore(var time):
	#highest score if level completed in 10sec or less
	if time <= 10:
		score = 40
	#1 point reduction for each additional second
	#players get 5 points for just completing the level
	else:
		score = 40 - (time - 10)
		if score < 5:
			score = 5
	
func showResults():
	var timeResult = round(timer)
	disable_buttons()
	calculateScore(timeResult)
	$Return.disabled = false
	$Return.show()
	$Message.text = "Level complete!"
	$Score2.show()
	$levelScore.text = "Score: " + str(score)
	$levelScore.show()
		
func control_top():
	#starts water animation on top route
	if bottom_cost > top_cost and !sent_bottom and !sent_top:
		if $Water/"1".get_cell(3, 7) == -1:
			disable_buttons()
			$Water/"1".set_cell(3, 7, $Water/"1".tile_set.find_tile_by_name("full_cap_2.tres 0"))
		elif $Water/"1".get_cell(26, 6) == -1:
			disable_buttons()
			$Water/"1".set_cell(top_x, 6, $Water/"1".tile_set.find_tile_by_name("cap_2.tres 1"))
			top_x = top_x + 1
		elif $Water/"1".get_cell(26, 7) == -1:
			disable_buttons()
			$Water/"1".set_cell(26, 7, $Water/"1".tile_set.find_tile_by_name("full_cap_2.tres 0"))
			change_1 = true
		else:
			if change_1:
				$Shower/High.show()
				$Shower/Low.hide()
				$Shower/Soap.hide()
				$Shower/Happy.show()
				$Shower/Sad.hide()
				sent_top = true
				units_sent = 2
			change_1 = false

func control_bottom():
	#starts water animation on bottom route
	if bottom_cost < top_cost and !sent_bottom and !sent_top:
		if $Water/"2".get_cell(23, 9) == -1:
			disable_buttons()
			$Water/"2".set_cell(bottom_x, 9, $Water/"2".tile_set.find_tile_by_name("cap_1.tres 0"))
			bottom_x = bottom_x + 1
			change_2 = true
		else:
			if change_2:
				enable_buttons()
				$Shower/High.hide()
				$Shower/Low.show()
				$Shower/Soap.show()
				$Shower/Happy.hide()
				$Shower/Sad.show()
				sent_bottom = true
				units_sent = 1
				bottom_x = 6
			change_2 = false
			
	#undoes water animation on bottom route
	if bottom_cost > top_cost and sent_bottom:
		if $Water/"2".get_cell(23, 9) != -1:
			disable_buttons()
			$Water/"2".set_cell(bottom_x, 9, -1)
			bottom_x = bottom_x + 1
			change_2 = true
		else:
			if change_2:
				$Shower/High.hide()
				$Shower/Low.hide()
				$Shower/Soap.show()
				$Shower/Happy.hide()
				$Shower/Sad.show()
				sent_bottom = false
				units_sent = 0
				bottom_x = 6
			change_2 = false

func disable_buttons():
	$Cost/Bottom_minus.disabled = true
	$Cost/Bottom_plus.disabled = true
	$Cost/Top_minus.disabled = true
	$Cost/Top_plus.disabled = true
	
func enable_buttons():
	$Cost/Bottom_minus.disabled = false
	$Cost/Bottom_plus.disabled = false
	$Cost/Top_minus.disabled = false
	$Cost/Top_plus.disabled = false

#these functions update the cost of each route based on user input
#minimum cost is 1, maximum cost is 10
func _on_Top_plus_pressed():
	if top_cost < 10:
		top_cost = top_cost + 1
		clicks = clicks + 1

func _on_Top_minus_pressed():
	if top_cost != 1:
		top_cost = top_cost - 1
		clicks = clicks + 1

func _on_Bottom_plus_pressed():
	if bottom_cost < 10:
		bottom_cost = bottom_cost + 1
		clicks = clicks + 1

func _on_Bottom_minus_pressed():
	if bottom_cost != 1:
		bottom_cost = bottom_cost - 1
		clicks = clicks + 1

#tooltip controls
#hint
func _on_Button_Hint_pressed():
	$H_Control.hide()
	$H_Control/Button_Hint.disabled = true
	
#shower
func _on_S_Control_mouse_entered():
	$Tooltips/S_Panel.show()
	$Tooltips/S_Panel/Label.text = "Shower\n" + str(units_sent) + "/" + str(units_required) + " units\n\nReceives water from water source"

func _on_S_Control_mouse_exited():
	$Tooltips/S_Panel.hide()

#pipes
#pipes top
func _on_P1_Control_mouse_entered():
	$Tooltips/P1_Panel.show()
	$Tooltips/P1_Panel/Label.text = "Pipes\n\nCost: " + str(top_cost) + "\nCapacity: 2"

func _on_P1_Control_mouse_exited():
	$Tooltips/P1_Panel.hide()
	
#pipes bottom
func _on_P2_Control_mouse_entered():
	$Tooltips/P2_Panel.show()
	$Tooltips/P2_Panel/Label.text = "Pipes\n\nCost: " + str(bottom_cost) + "\nCapacity: 1"

func _on_P2_Control_mouse_exited():
	$Tooltips/P2_Panel.hide()

#exit
func _on_Button_pressed():
	main_scene._comp(2)
	self.queue_free()
