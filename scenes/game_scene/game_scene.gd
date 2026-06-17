class_name GameScene extends Node2D

@onready var cursor = %cursor
@onready var timer = %Timer
@onready var win_lose_manager = %WinLoseManager

# TODO: DELETE LATER WHEN DONE TESTING
@onready var thing = %Thing

@export var TOTAL_ANOMALY_COUNT: int
@export var DARKEN_START_TIME: float
@export var MUTATE_START_TIME: float
@export var MUTATE_END_TIME: float
@export var TOTAL_TIME: float

var event_list: Array[Event]

var current_anomaly_count: int = 0
var anomaly_list: Array[Thing] # List of the objects that are currently set as anomalies

#region Things
const LAVA_LAMP_SCENE: PackedScene = preload("uid://w7sjbxb1g1bd")
#endregion


func _ready() -> void:
	
	# ----- Timer Setup ----- 
	timer.time_total = TOTAL_TIME
	timer.start()
	
	
	# ----- Event Scheduling -----
	event_list.append(Event.new(Event.Type.DARKEN, DARKEN_START_TIME))
	
	var mutate_interval: float = 0
	if TOTAL_ANOMALY_COUNT > 1:
		mutate_interval = (MUTATE_END_TIME - MUTATE_START_TIME) / (TOTAL_ANOMALY_COUNT - 1)
	
	for i in TOTAL_ANOMALY_COUNT:
		var time = MUTATE_START_TIME + mutate_interval * i
		event_list.append(Event.new(Event.Type.MUTATE, time))
	
	event_list.append(Event.new(Event.Type.TIME_UP, TOTAL_TIME))


func _process(_delta: float) -> void:
	var i = 0
	while i < event_list.size():
		var event = event_list[i]
		if timer.time_elapsed >= event.date: 
			event_list.remove_at(i)
			do_event(event)
		else: 
			i += 1

func do_event(event: Event):
	match event.type:
		Event.Type.DARKEN:
			print("%.2f - DOING DARKEN EVENT" % event.date)
			
		Event.Type.MUTATE:
			print("%.2f - DOING MUTATE EVENT" % event.date)
			thing.make_anomaly() # temporary
			# TODO: get the next valid mutation in the random mutation list
			
		Event.Type.TIME_UP:
			print("%.2f - DOING TIME_UP EVENT" % event.date)


func _on_win_button_pressed() -> void:
	win_lose_manager.game_won()
	pass # Replace with function body.


func _on_lose_button_pressed() -> void:
	win_lose_manager.game_lost()
	pass # Replace with function body.


# Keep a list of all things
# after some time, convert a thing to its anomoly variant
