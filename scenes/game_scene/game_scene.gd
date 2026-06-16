class_name GameScene extends Node2D

@onready var cursor = %cursor
@onready var timer = %Timer
@onready var win_lose_manager = %WinLoseManager

var current_anomolies_count: int = 0
var anomolies_list: Array[Thing] # List of the objects that are currently set as anomolies


func _on_win_button_pressed() -> void:
	win_lose_manager.game_won()
	pass # Replace with function body.


func _on_lose_button_pressed() -> void:
	win_lose_manager.game_lost()
	pass # Replace with function body.


# Keep a list of all things
# after some time, convert a thing to its anomoly variant
