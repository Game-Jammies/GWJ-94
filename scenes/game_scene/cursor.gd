"""
This script handles items following and related to the cursor
"""

extends Node2D

@onready var light: PointLight2D = %PointLight2D
@onready var progress: TextureProgressBar = %TextureProgressBar

#how much time to completely fill, increase per second
@export var fill_time: float = 3.0

#mouse is pushed down
var mouse_down : bool = false
	
func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()

	light.global_position = mouse_pos
	progress.global_position = Vector2(mouse_pos.x - 32, mouse_pos.y - 32)

	if mouse_down:
		progress.value += (progress.max_value / fill_time) * delta
		if progress.value >= progress.max_value:
			progress.value = progress.max_value
	else:
		progress.value = 0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		mouse_down = event.pressed
