#Kirin Hardinger
#July 2022

extends Sprite

signal click

func _ready():
	pass

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		if get_rect().has_point(to_local(event.position)):
			emit_signal("click")
