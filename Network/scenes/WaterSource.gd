#Kirin Hardinger
#July 2022

extends Area2D

signal clicked

func _ready():
	pass

func send():
	emit_signal("clicked")
