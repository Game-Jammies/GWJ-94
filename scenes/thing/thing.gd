class_name Thing extends Node2D

# Clickable objects
signal anomaly_found()
signal incorrect_guess

@onready var sprite: Sprite2D = %Sprite2D
@onready var area: Area2D = %Area2D
@onready var selecting: AudioStreamPlayer = $"../../AudioManager/selecting"
@onready var successful_select: AudioStreamPlayer = $"../../AudioManager/successfulSelect"
@onready var unsuccessful_select: AudioStreamPlayer = $"../../AudioManager/unsuccessfulSelect"

var is_anomaly: bool = false
var mouse_over: bool = false # Whether the mouse is currently hovering
var mouse_down: bool = false # If the mouse is held down

@export_group("Normal Configurations")
@export var norm_pos: Vector2 = Vector2(position.x, position.y)
@export var norm_rot: float = 0.0
@export var norm_scale: Vector2 = Vector2(1.0,1.0)
@export var norm_sprite: Texture2D

@export_group("Anomaly Configurations")
@export var anom_pos: Vector2 = Vector2(0.0,0.0)
@export var anom_rot: float = 0.0
@export var anom_scale: Vector2 = Vector2(1.0,1.0)
@export var anom_sprite: Texture2D

func _ready() -> void:
	add_to_group("things")
	sprite.set_texture(norm_sprite)
	make_normal()

## The normal configurations of a thing
func make_normal() -> void:
	if anom_sprite:
		sprite.set_texture(norm_sprite)
	set_global_position(norm_pos)
	set_rotation_degrees(norm_rot)
	set_scale(norm_scale)
	is_anomaly = false

## The configurations of a thing in its anomoly form
func make_anomaly() -> void:
	if anom_sprite:
		sprite.set_texture(anom_sprite)
	set_global_position(anom_pos)
	set_rotation_degrees(anom_rot)
	set_scale(anom_scale)
	is_anomaly = true

func _on_area_2d_mouse_entered() -> void:
	#print("mouse entered")
	mouse_over = true
	if sprite.material.shader != null:
		sprite.material.set_shader_parameter("is_hovered", true)

func _on_area_2d_mouse_exited() -> void:
	mouse_over = false
	if sprite.material.shader != null:
		sprite.material.set_shader_parameter("is_hovered", false)
	
func _process(_delta: float) -> void:
	if mouse_down:
		_while_held()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#initial click
		if event.is_pressed() and mouse_over:
			mouse_down = true
			selecting.play()
			_on_click_started()
		
		#mouse release
		elif not event.is_pressed() and mouse_down:
			mouse_down = false
			selecting.stop()
			_on_click_released()

func _on_click_started() -> void: pass
	#print("Sprite is clicked")
	
func _while_held() -> void:
	#print("Mouse held down!")
	pass
	"""TODO: put the circle around the mouse location?
	Timer for like 3s and resolve
	"""

func _on_click_released() -> void:
	#print("Released")
	pass


func _on_cursor_thing_select(pos: Vector2) -> void:
	"""TODO: figure out a less expensive way to tell if a vector2 is in an area2d"""
	var query := PhysicsPointQueryParameters2D.new()
	
	query.position = pos
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.collision_mask = area.collision_mask
	
	var space := get_world_2d().direct_space_state
	var results := space.intersect_point(query)
	for result in results:
		if result.collider == area:
			_thing_selected()
	"""if area.position.x < pos.x < area.position.x + area.width \
	and area.position.y > pos.y > area.position.y + area.height:
		print("yes")"""

func _thing_selected():
	"""The thing has been selected"""
	print("Selected " + self.name)
	selecting.stop()
	# Check if thing is anomaly
	if is_anomaly:
		successful_select.play()
		make_normal()
		anomaly_found.emit()
		pass
	else:
		unsuccessful_select.play()
		incorrect_guess.emit()
		pass
	pass
