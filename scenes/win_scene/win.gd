@tool
extends OverlaidWindow

signal restart_pressed
signal main_menu_pressed

func _on_play_again_button_pressed() -> void:
	close()
	restart_pressed.emit()

func _on_main_menu_button_pressed() -> void:
	close()
	main_menu_pressed.emit()
