extends Node


# Declare member variables here. Examples:
# var a = 2
# v
const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
#relative path to the database
var db_name = "res://game_data/networking_game.db"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func commitDataToDB():
	db = SQLite.new()
	db.path = db.name
	db.open_db()
	#define which table you'll need
	var tableName = "PlayerInfo"
	#create dictionary
	var dict : Dictionary = Dictionary()
	dict["user_name"] = "this is a test user"
	db.insert_row(tableName.dict)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
