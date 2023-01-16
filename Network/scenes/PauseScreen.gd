#Kirin Hardinger
#Created November 2022

extends CanvasLayer

#allows the pause menu to be activated
var enable = false

#connects to Main node for scene management
signal exit_pause

#ui_cancel is ESC key
#shows menu and pauses the scene
func _process(delta):
	if Input.is_action_pressed("ui_cancel") and enable:
		$Window.show()
		get_tree().paused = true

#enable/disable called in the Main node
func enable():
	enable = true
	
func disable():
	enable = false

#unpause the scene and hide the menu
func _on_Resume_pressed():
	get_tree().paused = false
	$Window.hide()

#unhide the scene, hide the menu, and connect to the Main node to go back to the level selection screen
func _on_Exit_pressed():
	get_tree().paused = false
	$Window.hide()
	emit_signal("exit_pause")
