class_name Thing extends Node2D

# Clickable objects

@onready var sprite: Sprite2D = %Sprite2D
@onready var area: Area2D = %Area2D

var is_misplaced: bool
var mouse_over: bool = false #whether the mouse is currently hovering
var mouse_down: bool = false #if the mouse is held down

func _ready() -> void:
	add_to_group("things")

func _on_area_2d_mouse_entered() -> void:
	print("mouse entered")
	mouse_over = true
	sprite.material.set_shader_parameter("is_hovered", true)

func _on_area_2d_mouse_exited() -> void:
	mouse_over = false
	sprite.material.set_shader_parameter("is_hovered", false)
	
func _process(_delta: float) -> void:
	if mouse_down:
		_while_held()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#initial click
		if event.is_pressed() and mouse_over:
			mouse_down = true
			_on_click_started()
		
		#mouse release
		elif not event.is_pressed() and mouse_down:
			mouse_down = false
			_on_click_released()

func _on_click_started() -> void:
	print("Sprite is clicked")
	
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
	pass
