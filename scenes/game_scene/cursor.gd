"""
This script handles items following and related to the cursor
"""

class_name Cursor extends Node2D

@onready var light: PointLight2D = %PointLight2D
@onready var progress: TextureProgressBar = %TextureProgressBar

#how much time to completely fill, increase per second
@export var fill_time: float = 2.0

#mouse is pushed down
var mouse_down : bool = false
var cursor_pos : Vector2
var cursor_screen_pos : Vector2
var finished : bool = false

#signals
signal thing_select(pos: Vector2)
	
func _process(delta: float) -> void:	
	#update positions
	if not mouse_down:
		light.global_position = get_global_mouse_position()
	else:
		light.global_position = cursor_pos
	progress.position = Vector2(cursor_screen_pos.x - progress.size.x/2, cursor_screen_pos.y - progress.size.y/2)

	if mouse_down:
		progress.value += (progress.max_value / fill_time) * delta
		if progress.value >= progress.max_value and not finished:
			progress.value = progress.max_value
			_thing_selected()
			finished = true
	else:
		progress.value = 0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		mouse_down = event.pressed
		if mouse_down:
			progress.show()
			finished = false
			cursor_pos = get_global_mouse_position()
			cursor_screen_pos = get_viewport().get_mouse_position()

func _thing_selected() -> void:
	"""Trigger for when something has been selected"""
	progress.hide()
	#thing_select.emit(cursor_pos) #emit the selection
	get_tree().call_group("things", "_on_cursor_thing_select", cursor_pos)
