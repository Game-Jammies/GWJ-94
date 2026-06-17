extends Button

@onready var graphic = %Control

@onready var hidden_pos : Vector2
@onready var visible_pos : Vector2

func _ready() -> void:
	hidden_pos = Vector2(0, get_viewport_rect().size.y)
	visible_pos = Vector2(0,0)
	graphic.position.y = hidden_pos.y
	# Connect the hover built-in signals to our custom functions
	mouse_entered.connect(_on_button_hover_entered)
	mouse_exited.connect(_on_button_hover_exited)

func _on_button_hover_entered() -> void:
	print("Mouse is hovering over the button!")
	var tween = create_tween()
	print(graphic.position.y)
	tween.tween_property(graphic, "global_position:y", visible_pos.y, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_button_hover_exited() -> void:
	print("Mouse left the button!")
	var tween = create_tween()
	print(graphic.position.y)
	tween.tween_property(graphic, "global_position:y", hidden_pos.y, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
