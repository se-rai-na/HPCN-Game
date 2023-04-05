#Kirin Hardinger
#Created July 2022

extends Node

#connects to LevelSelectionScreen :: display()
#takes users to level selection
signal play_pressed

#RGB + opacity color values for "play" button
var default_color = Color(0.93, 0.87, 0.83, 1)
var hover_color = Color(0.92, 0.85, 0.6, 1)
var pressed_color = Color(0.96, 0.53, 0.31, 1)

func _ready():
	$playButton.show()
	
	#assigns colors
	#default color
	$playButton.set("custom_colors/font_color", default_color)
	
	#color on hover
	$playButton.set("custom_colors/font_color_hover", hover_color)
	
	#color on pressed
	$playButton.set("custom_colors/font_color_pressed", pressed_color)

func _on_button_pressed():
	#moves to level selection screen
	$playButton.hide()
	emit_signal("play_pressed")
