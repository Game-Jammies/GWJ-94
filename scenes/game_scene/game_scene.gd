class_name GameScene extends Node2D

@onready var cursor = %cursor
@onready var timer = %Timer
@onready var win_lose_manager = %WinLoseManager

# TODO: DELETE LATER WHEN DONE TESTING
@onready var thing = %Thing

var current_anomolies_count: int = 0
var anomolies_list: Array[Thing] # List of the objects that are currently set as anomolies

#region Things
const LAVA_LAMP_SCENE: PackedScene = preload("uid://w7sjbxb1g1bd")
#endregion

func _ready() -> void:
	timer.timer_at_0.connect(lose_game)
	thing.make_anomaly()
	current_anomolies_count += 1
	pass


func _process(delta: float) -> void:
	
	if current_anomolies_count <= 0:
		win_game()



func win_game() -> void:
	win_lose_manager.game_won()


func lose_game() -> void: 
	win_lose_manager.game_lost()


# Keep a list of all things
# after some time, convert a thing to its anomoly variant
