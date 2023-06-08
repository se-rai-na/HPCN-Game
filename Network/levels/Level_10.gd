extends Node

#timer controls the speed that water tiles populate
var _timer = null

var cost_1 = 4
var cost_2 = 1
var cost_3 = 3
var cost_4 = 2
var cost_5 = 1
var cost_6 = 4
var cost_7 = 1
var cost_8 = 4
var cost_9 = 3

var sent_1 = false
var sent_2 = true
var sent_3 = false
var sent_4 = true
var sent_5 = true
var sent_6 = false
var sent_7 = true
var sent_8 = false
var sent_9 = true

signal change_route(new_route)

var main_scene

var sources_used = 0
var route_costs = [0,0,0,0,0,0]
var route_is_split = [false,  false, false, false, false, false]
var active_routes = [1, 4, 5]
var left_split = false #7
var top_split = false #8
var bottom_split = false #9

var x_3 = 11
var x_4 = 5
var x_5 = 5
var x_8 = 18
var x_9 = 25
var y_9 = 5

var units_sent_1 = 0
var units_sent_2 = 2
var units_sent_3 = 0
var units_sent_5 = 1
var units_sent_8 = 0
var units_sent_9 = 1


var shower1_req_units = 3
var shower2_req_units = 4
var shower3_req_units = 1

func _ready():
	main_scene = get_node(get_parent().get_path())

	#this timer is used in water animation - how fast every tile is placed
	#it connects to each function that starts the water animation down a particular route
	_timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "update_route_costs")	
	_timer.connect("timeout", self, "control_1")
	_timer.connect("timeout", self, "control_2")
	_timer.connect("timeout", self, "control_3")	
	_timer.connect("timeout", self, "control_4")
	_timer.connect("timeout", self, "control_5")	
	_timer.connect("timeout", self, "control_6")
	_timer.connect("timeout", self, "control_7")			
	_timer.connect("timeout", self, "control_8")
	_timer.connect("timeout", self, "control_9")	
		
		
		
	_timer.set_wait_time(0.12)  
	_timer.start()

	self.connect("change_route", self, "on_route_change")
func _process(delta):
	$Tooltips/P1_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/P2_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/P3_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/P4_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/P5_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/P6_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Tooltips/P7_Panel.rect_global_position = get_viewport().get_mouse_position()
	$Showers/Shower1/Score.text = str(units_sent_1 + units_sent_3) + "/3"
	$Showers/Shower2/Score.text = str(units_sent_8 + units_sent_9) + "/4"
	$Showers/Shower3/Score.text = str(units_sent_2 + units_sent_5) + "/1"
	$Cost/"1_cost".text = "Cost: " + str(cost_1)
	$Cost/"2_cost".text = "Cost: " + str(cost_2)
	$Cost/"3_cost".text = "Cost: " + str(cost_3)
	$Cost/"4_cost".text = "Cost: " + str(cost_4)
	$Cost/"5_cost".text = "Cost: " + str(cost_5)
	$Cost/"6_cost".text = "Cost: " + str(cost_6)
	$Cost/"7_cost".text = "Cost: " + str(cost_7)
	$Cost/"8_cost".text = "Cost: " + str(cost_8)
	$Cost/"9_cost".text = "Cost: " + str(cost_9)
	update_shower_spriites()

func update_shower_spriites():
	if shower1_req_units <= units_sent_1 + units_sent_3:
		$Showers/Shower1/High.show()
		$Showers/Shower1/Low.hide()
		$Showers/Shower1/Soap.hide()
		$Showers/Shower1/Happy.show()
		$Showers/Shower1/Sad.hide()	
	if shower2_req_units <= units_sent_8 + units_sent_9:
		$Showers/Shower2/High.show()
		$Showers/Shower2/Low.hide()
		$Showers/Shower2/Soap.hide()
		$Showers/Shower2/Happy.show()
		$Showers/Shower2/Sad.hide()	
	if shower3_req_units <= units_sent_2 + units_sent_5:
		$Showers/Shower3/High.show()
		$Showers/Shower3/Low.hide()
		$Showers/Shower3/Soap.hide()
		$Showers/Shower3/Happy.show()
		$Showers/Shower3/Sad.hide()
	if shower1_req_units == units_sent_1 + units_sent_3 and shower2_req_units == units_sent_8 + units_sent_9 and shower3_req_units <= units_sent_2 + units_sent_5:
		$Return.disabled = false
		$Message.text = "Level complete!"
		$Return.show() 

func update_route_costs():
	print(active_routes)
	print(route_is_split)
	# left -> up
	route_costs[0] = cost_4 + cost_1
	
	# left -> down	
	route_costs[1] = cost_4 + cost_2
	
	# up -> left	
	route_costs[2] = cost_6 + cost_3
	
	# up -> right	
	route_costs[3] = cost_6 + cost_8
	
	# down -> left	
	route_costs[4] = cost_7 + cost_5
	
	# down -> right	
	route_costs[5] = cost_7 + cost_9

func on_route_change(new_route):
	print("in route change signal")
	print("new route: ")
	print(new_route)
	if new_route in [2,3]:
		$Water/"6".set_cell(15, 4, $Water/"6".tile_set.find_tile_by_name("full_cap_2.tres 1"))
		$Water/"6".set_cell(15, 5, $Water/"6".tile_set.find_tile_by_name("full_cap_2.tres 1"))
		$Water/"6".set_cell(14, 4, $Water/"6".tile_set.find_tile_by_name("full_cap_2.tres 1"))
		$Water/"6".set_cell(14, 5, $Water/"6".tile_set.find_tile_by_name("full_cap_2.tres 1"))
		sent_6 = true
	elif new_route in [0,1]:
		$Water/"4".set_cell(11, 7, $Water/"4".tile_set.find_tile_by_name("cap_2.tres 0"))		
		$Water/"4".set_cell(10, 7, $Water/"4".tile_set.find_tile_by_name("cap_2.tres 0"))
		$Water/"4".set_cell(9, 7, $Water/"4".tile_set.find_tile_by_name("cap_2.tres 0"))
		$Water/"4".set_cell(8, 7, $Water/"4".tile_set.find_tile_by_name("cap_2.tres 0"))
		$Water/"4".set_cell(7, 7, $Water/"4".tile_set.find_tile_by_name("cap_2.tres 0"))		
		$Water/"4".set_cell(6, 7, $Water/"4".tile_set.find_tile_by_name("cap_2.tres 0"))
		$Water/"4".set_cell(5, 7, $Water/"4".tile_set.find_tile_by_name("cap_2.tres 0"))
		$Water/"4".set_cell(4, 7, $Water/"4".tile_set.find_tile_by_name("cap_2.tres 0"))		
		sent_4 = true
		
	active_routes.append(new_route)
func control_1():
	if not 0 in active_routes and not route_is_split[0]:
		$Water/"1".set_cell(1, 5, -1)
		$Water/"1".set_cell(1, 4, -1)
		sent_1 = false
		units_sent_1 = 0
	if cost_1 != cost_2:
		route_is_split[0] = false
	if 1 in active_routes and cost_1 == cost_2:
		route_is_split[0] = true
		units_sent_1 = 1
		units_sent_2 = 1
		$Water/"1".set_cell(1, 5, -1)
		$Water/"1".set_cell(1, 4, -1)
		$Water/"1".set_cell(1, 5, $Water/"1".tile_set.find_tile_by_name("split.tres 4"))
		$Water/"1".set_cell(1, 4, $Water/"1".tile_set.find_tile_by_name("split.tres 4"))
		sent_1 = false
		
	if 0 in active_routes:
		units_sent_1 = (2 if (not route_is_split[1] and not 1 in active_routes) else 1)		
		if cost_1 > cost_2 and not 1 in active_routes:
			$Water/"1".set_cell(1, 5, -1)
			$Water/"1".set_cell(1, 4, -1)
			sent_1 = false
			units_sent_1 = 0
			units_sent_2 = 2
			active_routes.remove(0)
			active_routes.append(1)
		elif $Water/"1".get_cell(1,4) != $Water/"1".tile_set.find_tile_by_name("full_cap_2.tres 1"):
			$Water/"1".set_cell(1, 5, $Water/"1".tile_set.find_tile_by_name("full_cap_2.tres 1"))
			$Water/"1".set_cell(1, 4, $Water/"1".tile_set.find_tile_by_name("full_cap_2.tres 1"))
			units_sent_1 = 2
			units_sent_2 = 0
			sent_1 = true
	"""
	if sent_4:
		#Split water animation
		if cost_1 == cost_2:
			if not 0 in active_routes:
				route_is_split[0] = true
				units_sent_1 = 1
				units_sent_2 = 1
			if sent_1:
				$Water/"1".set_cell(1, 5, -1)
				$Water/"1".set_cell(1, 4, -1)
			if $Water/"1".get_cell(1, 4) == -1:
				$Water/"1".set_cell(1, 5, $Water/"1".tile_set.find_tile_by_name("split.tres 4"))
				$Water/"1".set_cell(1, 4, $Water/"1".tile_set.find_tile_by_name("split.tres 4"))
				sent_1 = false
		elif cost_1 < cost_2:
			$Water/"1".set_cell(1, 5, $Water/"1".tile_set.find_tile_by_name("full_cap_2.tres 1"))
			$Water/"1".set_cell(1, 4, $Water/"1".tile_set.find_tile_by_name("full_cap_2.tres 1"))
			if not 0 in active_routes:
				active_routes.append(0)
			units_sent_1 = 2
			units_sent_2 = 0
			sent_1 = true
			"""
				
				

func control_2():
	if cost_1 != cost_2:
		route_is_split[1] = false
	if 0 in active_routes and cost_1 == cost_2:
		route_is_split[1] = true
		units_sent_1 = 1
		units_sent_2 = 1
		$Water/"2".set_cell(1, 10, -1)
		$Water/"2".set_cell(1, 11, -1)
		$Water/"2".set_cell(1, 10, $Water/"1".tile_set.find_tile_by_name("split.tres 4"))
		$Water/"2".set_cell(1, 11, $Water/"1".tile_set.find_tile_by_name("split.tres 4"))
		sent_2 = false
		
	if 1 in active_routes:
		units_sent_2 = (2 if (not route_is_split[0] and not 0 in active_routes) else 1)
		if cost_1 < cost_2 and not 0 in active_routes:
			$Water/"2".set_cell(1, 10, -1)
			$Water/"2".set_cell(1, 11, -1)
			sent_1 = false
			units_sent_2 = 0
			units_sent_1 = 2
			active_routes.remove(1)
			active_routes.append(0)
		elif $Water/"2".get_cell(1,11) == -1:
			$Water/"2".set_cell(1, 10, $Water/"2".tile_set.find_tile_by_name("full_cap_2.tres 1"))
			$Water/"2".set_cell(1, 11, $Water/"2".tile_set.find_tile_by_name("full_cap_2.tres 1"))
			units_sent_2 = 2
			units_sent_1 = 0
			sent_2 = true
	"""
	if cost_1 != cost_2:
		route_is_split[1] = false
	if sent_1:
		$Water/"2".set_cell(1, 10, -1)
		$Water/"2".set_cell(1, 11, -1)
		sent_2 = false
		active_routes.erase(1)
	if sent_4:
	#Split water animation if costs are same
		if cost_1 == cost_2:
			if not 1 in active_routes:
				route_is_split[1] = true
				units_sent_2 = 1
				units_sent_1 = 1
			if sent_2:
				$Water/"2".set_cell(1, 10, -1)
				$Water/"2".set_cell(1, 11, -1)
			if $Water/"2".get_cell(1, 11) == -1:
				$Water/"2".set_cell(1, 10, $Water/"2".tile_set.find_tile_by_name("split.tres 4"))
				$Water/"2".set_cell(1, 11, $Water/"2".tile_set.find_tile_by_name("split.tres 4"))
				sent_2 = false
		#full water to pipe 2
		elif cost_2 < cost_1:
				$Water/"2".set_cell(1, 10, $Water/"2".tile_set.find_tile_by_name("full_cap_2.tres 1"))
				$Water/"2".set_cell(1, 11, $Water/"2".tile_set.find_tile_by_name("full_cap_2.tres 1"))
				sent_2 = true
				units_sent_2 = 2
				units_sent_1 = 0
				if not 1 in active_routes:
					active_routes.append(1)
		"""
		
func control_3():
	if cost_3 != cost_8:
		route_is_split[2] = false
	if 3 in active_routes and cost_8 == cost_3:
	#Split water animation
		units_sent_3 = 2
		units_sent_8 = 2
		route_is_split[2] = true
		if not sent_3:
			if $Water/"3".get_cell(5, 2) == -1:
				$Water/"3".set_cell(x_3, 2, $Water/"3".tile_set.find_tile_by_name("cap_2.tres 0"))
				x_3 -= 1
			else:
				sent_3 = true
	if 2 in active_routes or 3 in active_routes:
		if not sent_3 and 2 in active_routes:
			if $Water/"3".get_cell(5, 2) == -1:
				$Water/"3".set_cell(x_3, 2, $Water/"3".tile_set.find_tile_by_name("cap_2.tres 0"))
				x_3 -= 1
			else:
				units_sent_3 = 2
				sent_3 = true
		if cost_3 > cost_8 and sent_3 and not 3 in active_routes:
			if $Water/"3".get_cell(11, 2) != -1:
				$Water/"3".set_cell(x_3, 2, -1)
				x_3 += 1
			else:
				sent_3 = false
				x_3 = 11
				units_sent_3 = 0
				units_sent_8 = 4
				if not 3 in active_routes:
					active_routes.erase(2)
					active_routes.append(3)
	if not 2 in active_routes and not route_is_split[2] and $Water/"3".get_cell(11, 2) != -1:
		$Water/"3".set_cell(x_3, 2, -1)
		x_3 += 1
	elif $Water/"3".get_cell(11, 2) == -1:
		x_3 = 11
		
func control_4():
	if 0 in active_routes:
		for r in range(2,6):
			if route_costs[0] > route_costs[r] and not r in active_routes and not route_is_split[r]:
				if not 1 in active_routes:
					$Water/"4".set_cell(4, 7, -1)					
					$Water/"4".set_cell(5, 7, -1)
					$Water/"4".set_cell(6, 7, -1)
					$Water/"4".set_cell(7, 7, -1)
					$Water/"4".set_cell(8, 7, -1)
					$Water/"4".set_cell(9, 7, -1)
					$Water/"4".set_cell(10, 7, -1)
					$Water/"4".set_cell(11, 7, -1)					
					sent_4 = false
				$Water/"1".set_cell(1, 4, -1)
				$Water/"1".set_cell(1, 5, -1)
				units_sent_1 = 0			
				sent_1 = false
				active_routes.erase(0)
				emit_signal("change_route", r)
	if 1 in active_routes:
		for r in range(2,6):
			if route_costs[1] > route_costs[r] and not r in active_routes and not route_is_split[r]:
				if not 0 in active_routes:
					$Water/"4".set_cell(4, 7, -1)					
					$Water/"4".set_cell(5, 7, -1)
					$Water/"4".set_cell(6, 7, -1)
					$Water/"4".set_cell(7, 7, -1)
					$Water/"4".set_cell(8, 7, -1)
					$Water/"4".set_cell(9, 7, -1)
					$Water/"4".set_cell(10, 7, -1)
					$Water/"4".set_cell(11, 7, -1)					
					$Water/"2".set_cell(1, 10, -1)
					$Water/"2".set_cell(1, 11, -1)		
					sent_2 = false
					sent_4 = false
					units_sent_2 = 0
				active_routes.erase(1)
				emit_signal("change_route", r)
	"""if sent_4:
		for i in range(2,6):
			if cost_4 + min(cost_1, cost_2) > route_costs[i] and not i in active_routes:
				sent_4 = false
				active_routes.erase(1)
				active_routes.erase(2)
				$Water/"1".set_cell(1, 5, -1)
				$Water/"1".set_cell(1, 4, -1)
				$Water/"2".set_cell(1, 10, -1)
				$Water/"2".set_cell(1, 11, -1)
				sent_1 = false
				sent_2 = false
				while $Water/"4".get_cell(10, 7) != -1:
					$Water/"4".set_cell(x_4, 7, -1)
					x_4 += 1
				emit_signal("change_route", i)		
				break"""
func control_5():
	if 4 in active_routes:
		if cost_9 < cost_5 and not 5 in active_routes:
			active_routes.erase(4)
			active_routes.append(5)
			sent_5 = false
			units_sent_5 = 0
		elif not sent_5:
			if $Water/"5".get_cell(5, 13) == -1:
				disable_buttons()
				$Water/"5".set_cell(x_5, 13, $Water/"5".tile_set.find_tile_by_name("full_cap_2.tres 1"))
				x_5 -= 1
			else:
				sent_5 = true
				units_sent_5 = 2
				enable_buttons()
	elif $Water/"5".get_cell(11, 13) != -1:
		$Water/"5".set_cell(x_5,13, -1)
		x_5 += 1
	else:
		sent_5 = false
		
func control_6():
	if 2 in active_routes:
		for r in [0,1,4,5]:
			if route_costs[2] > route_costs[r] and not r in active_routes and not route_is_split[r]:
				if not 3 in active_routes:
					$Water/"6".set_cell(15, 4, -1)
					$Water/"6".set_cell(15, 5, -1)
					$Water/"6".set_cell(14, 4, -1)
					$Water/"6".set_cell(14, 5, -1)
					sent_6 = false
				active_routes.erase(2)
				emit_signal("change_route", r)
				sent_3 = false
				units_sent_3 = 0	
	if 3 in active_routes:
		for r in [0,1,4,5]:
			if route_costs[3] > route_costs[r] and not r in active_routes and not route_is_split[r]:
				if not 2 in active_routes:
					$Water/"6".set_cell(15, 4, -1)
					$Water/"6".set_cell(15, 5, -1)
					$Water/"6".set_cell(14, 4, -1)
					$Water/"6".set_cell(14, 5, -1)
					sent_6 = false
				active_routes.erase(3)
				emit_signal("change_route", r)
				sent_8 = false
				units_sent_8 = 0
	"""
	if sent_6:
		for i in [0,1,4,5]:
			if cost_6 + min(cost_3, cost_8) > route_costs[i] and not i in active_routes and not route_is_split[i]:
				sent_6 = false
				active_routes.erase(2)
				active_routes.erase(3)
				sent_3 = false
				sent_5 = false
				$Water/"6".set_cell(13, 4, -1)
				$Water/"6".set_cell(13, 5, -1)
				$Water/"6".set_cell(14, 4, -1)
				$Water/"6".set_cell(14, 5, -1)
				emit_signal("change_route", i)
				
	"""		
				
func control_7():
	if 4 in active_routes:
		for r in [0,1,2,3]:
			if route_costs[4] > route_costs[r] and not r in active_routes and not route_is_split[r]:
				if not 5 in active_routes:
					$Water/"7".set_cell(14, 10, -1)
					$Water/"7".set_cell(14, 11, -1)
					sent_7 = false
				active_routes.erase(4)
				emit_signal("change_route", r)
				units_sent_5 = 0
	if 5 in active_routes:
		for r in [0,1,2,3]:
			if route_costs[5] > route_costs[r] and not r in active_routes and not route_is_split[r]:
				if not 4 in active_routes:
					$Water/"7".set_cell(14, 10, -1)
					$Water/"7".set_cell(14, 11, -1)
					sent_7 = false
				active_routes.erase(5)
				units_sent_9 = 0				
				emit_signal("change_route", r)
				
func control_8():
	if not route_is_split[3] and not 3 in active_routes and $Water/"8".get_cell(18, 2) != -1:
		$Water/"8".set_cell(x_8, 2, -1)
		$Water/"8".set_cell(x_8, 1, -1)		
		x_8 -= 1
		sent_8 = false
	elif $Water/"8".get_cell(18, 2) == -1:
		x_8 = 18
	if cost_3 != cost_8:
		route_is_split[3] = false
	if 2 in active_routes and cost_8 == cost_3:
		#Split water animation
		route_is_split[3] = true
		units_sent_3 = 2
		units_sent_8 = 2
		if $Water/"8".get_cell(22, 2) == -1:
				$Water/"8".set_cell(x_8, 2, $Water/"8".tile_set.find_tile_by_name("cap_2.tres 0"))
				
				x_8 += 1
		else:
			sent_8 = true
		
	if 3 in active_routes or 2 in active_routes:
		if not sent_8 and 3 in active_routes:
			if $Water/"8".get_cell(22, 2) == -1:
				if not 2 in active_routes and not route_is_split[2]:
					$Water/"8".set_cell(x_8, 2, $Water/"8".tile_set.find_tile_by_name("full_cap_2.tres 1"))
					$Water/"8".set_cell(x_8, 1, $Water/"8".tile_set.find_tile_by_name("cap_2.tres 0"))					
					x_8 += 1
			else:
				units_sent_8 = 4
				sent_8 = true
		if cost_3 < cost_8 and sent_8 and not 2 in active_routes:
			if $Water/"8".get_cell(18, 2) != -1:
				$Water/"8".set_cell(x_8, 2, -1)
				x_8 -= 1
			else:
				units_sent_8 = 0
				units_sent_3 = 2
				sent_8 = false
				x_8 = 18
				if not 2 in active_routes:
					active_routes.erase(3)
					active_routes.append(2)
	elif $Water/"8".get_cell(18, 2) != -1:
		$Water/"8".set_cell(x_8, 2, -1)
		$Water/"8".set_cell(x_8, 1, -1)		
		x_8 -= 1
	elif $Water/"8".get_cell(18, 2) == -1:
		x_8 = 18
func control_9():
	if 5 in active_routes:
		units_sent_9 = (1 if 4 in active_routes else 2)
		if cost_9 > cost_5 and not 4 in active_routes:
			active_routes.erase(5)
			active_routes.append(4)
			sent_9 = false
			units_sent_9 = 0
		elif not sent_9:
			disable_buttons()
			if $Water/"9".get_cell(25, 13) == -1:
				$Water/"9".set_cell(x_9, 13, $Water/"9".tile_set.find_tile_by_name("cap_2.tres 0"))
				x_9 += 1
			elif $Water/"9".get_cell(25, 5) == -1:
				$Water/"9".set_cell(25,y_9, $Water/"9".tile_set.find_tile_by_name("full_cap_2.tres 1"))
				y_9 -= 1
			else:
				sent_9 = true
				units_sent_9 = 2
				enable_buttons()
	elif $Water/"9".get_cell(25, 13) != -1:
		disable_buttons()
		$Water/"9".set_cell(25,y_9, -1)
		y_9 += 1
	elif $Water/"9".get_cell(17, 13) != -1:
		$Water/"9".set_cell(x_9,13, -1)
		x_9 -= 1
	else:
		enable_buttons()
		sent_9 = false
		x_9 = 17
		y_9 = 13
					
		
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
	$Cost/"8_plus".disabled = false 
	$Cost/"8_minus".disabled = false
	$Cost/"9_plus".disabled = false 
	$Cost/"9_minus".disabled = false
	
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
	$Cost/"8_plus".disabled = true 
	$Cost/"8_minus".disabled = true
	$Cost/"9_plus".disabled = true 
	$Cost/"9_minus".disabled = true
	


func _on_C1_Control_mouse_entered():
	pass # Replace with function body.


func _on_P1_Control_mouse_entered():
	$Tooltips/P1_Panel.show()
	$Tooltips/P1_Panel/Label.text = "Pipes\n\nCost: " + str(cost_1) + "\nCapacity: 1"

func _on_P1_Control_mouse_exited():
	$Tooltips/P1_Panel.hide()


func _on_1_plus_pressed():
	if cost_1 < 10:
		cost_1 += 1
func _on_1_minus_pressed():
	if cost_1 > 1:
		cost_1 -= 1
	
func _on_2_plus_pressed():
	if cost_2 < 10:
		cost_2 += 1
func _on_2_minus_pressed():
	if cost_2 > 1:
		cost_2 -= 1

func _on_3_plus_pressed():
	if cost_3 < 10:
		cost_3 += 1
func _on_3_minus_pressed():
	if cost_3 > 1:
		cost_3 -= 1

func _on_4_plus_pressed():
	if cost_4 < 10:
		cost_4 += 1
func _on_4_minus_pressed():
	if cost_4 > 1:
		cost_4 -= 1
		
func _on_5_plus_pressed():
	if cost_5 < 10:
		cost_5 += 1
func _on_5_minus_pressed():
	if cost_5 > 1:
		cost_5 -= 1

func _on_6_plus_pressed():
	if cost_6 < 10:
		cost_6 += 1
func _on_6_minus_pressed():
	if cost_6 > 1:
		cost_6 -= 1
		
func _on_7_plus_pressed():
	if cost_7 < 10:
		cost_7 += 1
func _on_7_minus_pressed():
	if cost_7 > 1:
		cost_7 -= 1
	
func _on_8_plus_pressed():
	if cost_8 < 10:
		cost_8 += 1
func _on_8_minus_pressed():
	if cost_8 > 1:
		cost_8 -= 1
		
func _on_9_plus_pressed():
	if cost_9 < 10:
		cost_9 += 1 
func _on_9_minus_pressed():
	if cost_9 > 1:
		cost_9 -= 1


func _on_Return_pressed():
	main_scene._comp(10)
	self.queue_free()


func _on_P2_Control_mouse_entered():
	$Tooltips/P2_Panel.show()
	$Tooltips/P2_Panel/Label.text = "Pipes\n\nCost: " + str(cost_2) + "\nCapacity: 2"


func _on_P2_Control_mouse_exited():
	$Tooltips/P2_Panel.hide()


func _on_P3_Control_mouse_entered():
	$Tooltips/P3_Panel.show()
	$Tooltips/P3_Panel/Label.text = "Pipes\n\nCost: " + str(cost_3) + "\nCapacity: 2"


func _on_P3_Control_mouse_exited():
	$Tooltips/P3_Panel.hide()


func _on_P4_Control_mouse_entered():
	$Tooltips/P4_Panel.show()
	$Tooltips/P4_Panel/Label.text = "Pipes\n\nCost: " + str(cost_4) + "\nCapacity: 2"

func _on_P4_Control_mouse_exited():
	$Tooltips/P4_Panel.hide()


func _on_P5_Control_mouse_entered():
	$Tooltips/P5_Panel.show()
	$Tooltips/P5_Panel/Label.text = "Pipes\n\nCost: " + str(cost_5) + "\nCapacity: 2"

func _on_P5_Control_mouse_exited():
	$Tooltips/P5_Panel.hide()


func _on_P6_Control_mouse_entered():
	$Tooltips/P6_Panel.show()
	$Tooltips/P6_Panel/Label.text = "Pipes\n\nCost: " + str(cost_6) + "\nCapacity: 4"


func _on_P6_Control_mouse_exited():
	$Tooltips/P6_Panel.hide()
	
func _on_P7_Control_mouse_entered():
	$Tooltips/P7_Panel.show()
	$Tooltips/P7_Panel/Label.text = "Pipes\n\nCost: " + str(cost_7) + "\nCapacity: 2"

func _on_P7_Control_mouse_exited():
	$Tooltips/P7_Panel.hide()
