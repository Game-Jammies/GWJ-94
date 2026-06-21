"""
This script handles items following and related to the cursor
"""

class_name Cursor extends Node2D

@onready var mouse_follow_node: Node2D = %MouseFollow
@onready var cutout_particles: CPUParticles2D = %CutoutParticles
@onready var progress: TextureProgressBar = %TextureProgressBar

#how much time to completely fill, increase per second
@export var FILL_TIME: float = 2.0

var mouse_down : bool = false
var cursor_pos : Vector2
var cursor_screen_pos : Vector2
var finished : bool = false

@onready var darkness_sprite: Sprite2D = %DarknessSprite
@onready var darkness_texture: GradientTexture2D
@export var DARKNESS_COLOR: Color
var darkness_opacity: float = 0.0

#signals
signal thing_select(pos: Vector2)


func _ready() -> void:
	darkness_texture = darkness_sprite.texture


func _process(delta: float) -> void:
	# update the darkness sprite's opacity in case the tween has changed it
	var new_color = Color(DARKNESS_COLOR, darkness_opacity)
	darkness_texture.gradient.set_color(0, new_color)
	
	#update positions
	if not mouse_down:
		mouse_follow_node.global_position = get_global_mouse_position()
		cutout_particles.global_position = get_global_mouse_position()
	else:
		mouse_follow_node.global_position = cursor_pos
		cutout_particles.global_position = cursor_pos
	progress.position = Vector2(cursor_screen_pos.x - progress.size.x/2, cursor_screen_pos.y - progress.size.y/2)

	if mouse_down:
		progress.value += (progress.max_value / FILL_TIME) * delta
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


func fade_darkness_opacity(opacity: float, duration: float) -> void:
	var tween: Tween = create_tween()
	#tween.set_ease(Tween.EASE_IN_OUT)
	#tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "darkness_opacity", opacity, duration)
