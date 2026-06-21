class_name GameScene extends Node2D

@onready var cursor = %Cursor
@onready var timer = %Timer
@onready var win_lose_manager = %WinLoseManager
@onready var camera: Camera2D = %Camera2D
@onready var thing_parent: Node2D = %ThingParent
@onready var canvas_modulate: CanvasModulate = %CanvasModulate
@onready var sfx_stairs: AudioStreamPlayer = $"AudioManager/Stairs"
@onready var sfx_win:    AudioStreamPlayer = $"AudioManager/win"
@onready var sfx_lose:   AudioStreamPlayer = $"AudioManager/lose"

const FLOOR_1_CAM_POS := Vector2(0.0, 0.0)
const FLOOR_2_CAM_POS := Vector2(0.0, -1080.0)

@export var TOTAL_ANOMALY_COUNT: int
@export var DARKEN_START_TIME: float
@export var DARKEN_COLOR: Color = Color.GRAY
@export var MUTATE_START_TIME: float
@export var MUTATE_END_TIME: float
@export var TOTAL_TIME: float

## Stores the original color of the CanvasModulate node
var initial_color: Color 

## List of events scheduled to happen during the game.
var event_list: Array[Event] = []

## List of potential Things to mutate. 
## Populated with visible children of "ThingParent" node, ordered randomly.
var thing_pool: Array[Thing] = [] 
var anomalies_found: int



func _ready() -> void:
	initial_color = canvas_modulate.color
	anomalies_found = 0
	
	
	# ----- Populate Thing Pool -----
	for thing in thing_parent.get_children():
		if thing.visible:
			thing_pool.append(thing)
			thing.anomaly_found.connect(_on_anomaly_found)
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
	if anomalies_found == TOTAL_ANOMALY_COUNT:
		win_game()

func do_event(event: Event):
	match event.type:
		Event.Type.DARKEN:
			print("%.2f - DOING DARKEN EVENT" % event.date)
			canvas_modulate.color = DARKEN_COLOR
			
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
	canvas_modulate.color = initial_color
	win_lose_manager.game_won()


func lose_game() -> void: 
	sfx_lose.play()
	timer.stop()
	canvas_modulate.color = initial_color
	win_lose_manager.game_lost()


func _on_anomaly_found() -> void:
	anomalies_found += 1

## Button to go up to the second floor
func _on_floor_1_stairs_button_pressed() -> void:
	sfx_stairs.play()
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(camera,"position",FLOOR_2_CAM_POS,1.0)


func _on_floor_2_stairs_button_pressed() -> void:
	sfx_stairs.play()
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(camera,"position",FLOOR_1_CAM_POS,1.0)
