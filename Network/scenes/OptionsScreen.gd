#Kirin Hardinger
#July 2022

extends Node

signal back_pressed

func _ready():
	hide_buttons()
	
	$fullscreen.pressed = OS.window_fullscreen
	
func display():
	show_buttons()	
	
func _on_X_pressed():
	hide_buttons()
	
	#moves back to start screen
	emit_signal("back_pressed")

func hide_buttons():
	$X.hide()
	get_tree().call_group("fullscreenInterface", "hide")

func show_buttons():
	$X.show()
	get_tree().call_group("fullscreenInterface", "show")
	
func _on_fullscreen_pressed():
	#toggles window fullscreen
	OS.set_window_fullscreen(!OS.window_fullscreen)
