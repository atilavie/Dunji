extends Control

func _on_play_button_up() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
func _on_quit_button_up() -> void:
	get_tree().quit()
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://Scenes/game.tscn")
func _ready() -> void:
	$Sprite2D.rotation_degrees = 0 if (GlobalOrientation.blue_perspective == true) else 180
