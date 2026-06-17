class_name GameTimer extends Panel

signal timer_at_0

var time: float = 5.0
var minutes: int = 0
var seconds: int = 0
var msec: float = 0

func _process(delta) -> void:
	time -= delta
	msec = fmod(time, 1) * 1000.0
	seconds = int(time) % 60
	minutes = int(time / 60) % 60
	$Minutes.text = "%d:" % minutes
	$Seconds.text = "%02d" % seconds
	
	if time <= 0.0:
		timer_at_0.emit()
		stop()

func stop() -> void:
	set_process(false)

func get_time_formatted() -> String:
	return "%d:%02d" % [minutes, seconds]
