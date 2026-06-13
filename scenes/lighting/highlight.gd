"""
This script highlights the sprite2d with the outline.tres shader when hovered over the mouse
"""

extends Sprite2D	


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Enabling/disabling the hover effect
	"""TODO: CAN do this better with Area2d -> Sprite2D and CollisionShape2D instead"""
	var mouse_pos = get_local_mouse_position()
	# get_rect() fetches the local size and boundaries of the sprite texture
	if get_rect().has_point(mouse_pos):
		material.set_shader_parameter("is_hovered", true)
	else:
		material.set_shader_parameter("is_hovered", false)
	

#Enabling/disabling the hover effect
func _on_mouse_entered() -> void:
	material.set_shader_parameter("is_hovered", true)


func _on_mouse_exited() -> void:
	material.set_shader_parameter("is_hovered", false)
