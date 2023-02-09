#Kirin Hardinger
#Created July 2022

extends Node

#timer controls the speed that water tiles populate
var _timer = null

#x coordinate for water tilemap
var x = 6

#keeps track of level complete conditions
var units_sent = 0
var units_required = 2

#cost of pipe
var cost = 1

#to calculate score
var clicks = 0

#scene management
var main_scene
signal comp_1

func _ready():
	#sets main scene to return when level is done
	main_scene = get_node(get_parent().get_path())
	
	#this timer is used in water animation - how fast every tile is placed
	_timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "control_route")
	_timer.set_wait_time(0.4) #this number is changed to adjust the speed
	_timer.start()
	
func _process(delta):
	#updates score
	$Score.text = str(units_sent) + "/" + str(units_required)
	$Cost/cost.text = "Cost: " + str(cost)
	
	#tooltps follow mouse
	$Tooltips/W_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/S_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/P_Panel.rect_global_position = get_viewport().get_mouse_position()
	var number = 10
	#evaluates win condition
	if units_sent == units_required:
		$Return.disabled = false
		$levelScore.text = str(number);
		$levelScore.show()
		$Score2.show()
		$Return.show()
		$Message_Success.show()

#starts water animation and adds water tiles to the tile map until the pipe is filled
func control_route():
	if $Water.get_cell(23, 9) == -1:
		disable_buttons()
		$Water.set_cell(x, 9, $Water.tile_set.find_tile_by_name("cap_2.tres 0"))
		x = x + 1
	else:
		enable_buttons()
		units_sent = 2
		$Shower/High.show()
		$Shower/Soap.hide()
		$Shower/Happy.show()
		$Shower/Sad.hide()

func _on_Button_pressed():
	main_scene._comp(1)
	self.queue_free()

func _on_plus_pressed():
	if cost < 10:
		cost = cost + 1
		clicks =+ clicks

func _on_minus_pressed():
	if cost != 1:
		cost = cost - 1
		clicks =+ clicks
		
func disable_buttons():
	$Cost/minus.disabled = true
	$Cost/plus.disabled = true
	
func enable_buttons():
	$Cost/minus.disabled = false
	$Cost/plus.disabled = false

#tooltip controls
#hint
func _on_Button_Hint_pressed():
	$H_Control.hide()
	$H_Control/Button_Hint.disabled = true

#Watersource
func _on_W_Control_mouse_entered():
	$Tooltips/W_Panel.show()

func _on_W_Control_mouse_exited():
	$Tooltips/W_Panel.hide()

#pipes
func _on_P_Control_mouse_entered():
	$Tooltips/P_Panel.show()
	$Tooltips/P_Panel/Label.text = "Pipes\nCost: " + str(cost) + "\nCapacity: 2\n\nWater travels through the path of least cost"

func _on_P_Control_mouse_exited():
	$Tooltips/P_Panel.hide()

func _on_S_Control_mouse_entered():
	$Tooltips/S_Panel.show()
	$Tooltips/S_Panel/Label.text = "Shower\n" + str(units_sent) + "/" + str(units_required) + "\nThis is the destination"

func _on_S_Control_mouse_exited():
	$Tooltips/S_Panel.hide()
