class_name GameTimer extends Panel

var time_total: float = 120.0
var time_elapsed: float = 0

var ticking: bool = false

func start() -> void: ticking = true
func stop() -> void: ticking = false


func _process(delta) -> void:
	if ticking: time_elapsed += delta
	
	var time_left = get_time_left()
	var seconds_left = int(time_left) % 60
	var minutes_left = int(time_left / 60) % 60
	$Minutes.text = "%d:" % minutes_left
	$Seconds.text = "%02d" % seconds_left

func get_time_left() -> float:
	return time_total - time_elapsed

func get_time_formatted() -> String:
	var time_left = get_time_left()
	var seconds = int(time_left) % 60
	var minutes = int(time_left / 60) % 60
	return "%d:%02d" % [minutes, seconds]
