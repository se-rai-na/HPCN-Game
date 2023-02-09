extends Node
 
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#var level_score = 0;

#scene management
var main_scene
signal comp_1

# Called when the node enters the scene tree for the first time.
func _ready():
	#sets main scene to return when level is done
	main_scene = get_node(get_parent().get_path())
	#prints the score for the current level
	$Score/"Level_Score".text = str("10");

#func score_calc(ideal_clicks, clicks):
	#if clicks == 2:
		#evel_score = 10;
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
