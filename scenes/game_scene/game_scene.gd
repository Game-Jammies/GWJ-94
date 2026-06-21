class_name GameScene extends Node2D

@onready var cursor: Cursor = %Cursor
@onready var timer = %Timer
@onready var win_lose_manager = %WinLoseManager
@onready var camera: Camera2D = %Camera2D
@onready var thing_parent: Node2D = %ThingParent
@onready var sfx_stairs: AudioStreamPlayer = $"AudioManager/Stairs"
@onready var sfx_win:    AudioStreamPlayer = $"AudioManager/win"
@onready var sfx_lose:   AudioStreamPlayer = $"AudioManager/lose"

@export var TOTAL_ANOMALY_COUNT: int
@export var DARKEN_START_TIME: float
@export var MUTATE_START_TIME: float
@export var MUTATE_END_TIME: float
@export var TOTAL_TIME: float

## List of events scheduled to happen during the game.
var event_list: Array[Event] = []

## List of potential Things to mutate. 
## Populated with visible children of "ThingParent" node, ordered randomly.
var thing_pool: Array[Thing] = [] 



func _ready() -> void:
	cursor.show()
	
	# ----- Populate Thing Pool -----
	for thing in thing_parent.get_children():
		if thing.visible:
			thing_pool.append(thing)
	thing_pool.shuffle()
	
	
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
			cursor.fade_darkness_opacity(1.0, 5.0)
			
		Event.Type.MUTATE:
			print("%.2f - DOING MUTATE EVENT" % event.date)
			var thing = thing_pool.pop_back()
			if thing:
				thing.make_anomaly()
			else: 
				printerr("Could not find a thing to mutate")
			
		Event.Type.TIME_UP:
			lose_game()
	pass



func win_game() -> void:
	sfx_win.play()
	timer.stop()
	cursor.fade_darkness_opacity(0.0, 0.75)
	win_lose_manager.game_won()


func lose_game() -> void: 
	sfx_lose.play()
	timer.stop()
	cursor.fade_darkness_opacity(0.0, 0.75)
	win_lose_manager.game_lost()
