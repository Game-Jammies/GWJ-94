class_name Thing extends Node2D

# Clickable objects

@onready var sprite: Sprite2D = %Sprite2D
@onready var area: Area2D = %Area2D

var is_misplaced: bool

func _on_area_2d_mouse_entered() -> void:
	print("mouse entered")
	pass # Replace with function body.
