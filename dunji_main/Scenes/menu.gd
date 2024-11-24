extends Control

var intro = false

func _ready():
	var tween = create_tween()
	var logo = $DunjiLogo
	var press_play = $PressToPlay
	tween.tween_property(press_play, "position", Vector2(328,297.5), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.parallel()
	tween.tween_property(logo, "position", Vector2(332,130), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
func _on_play_button_up() -> void:
	var tween = create_tween()
	var logo = $DunjiLogo
	var panel = $MenuPanel
	var button_play = $Play
	var button_quit = $Quit
	var settings = $Settings
	tween.tween_property(logo, "position", Vector2(logo.position.x,-100), 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.parallel()
	tween.tween_property(panel, "position", Vector2(-114.5,216.5), 0.6).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.parallel()
	tween.tween_property(button_play, "position", Vector2(-151,161), 0.6).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.parallel()
	tween.tween_property(settings, "position", Vector2(-151,197), 0.6).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.parallel()
	tween.tween_property(button_quit, "position", Vector2(-151,197+36), 0.6).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	await get_tree().create_timer(0.75).timeout
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	
func _on_quit_button_up() -> void:
	get_tree().quit()
func _input(event):
		if !intro:
			if event is InputEventKey:
				introduction()
			elif event is InputEventMouseButton:
				introduction()
func introduction(): 
	intro = true
	var tween = create_tween()
	var logo = $DunjiLogo
	var press_play = $PressToPlay
	var panel = $MenuPanel
	var button_play = $Play
	var button_quit = $Quit
	var settings = $Settings
	tween.tween_property(press_play, "position", Vector2(328,500), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.parallel()
	tween.tween_property(logo, "scale", Vector2(0.5,0.5), 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween.parallel()
	tween.tween_property(logo, "position", Vector2(logo.position.x,78), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	await get_tree().create_timer(0.3).timeout
	var tween2 = create_tween()
	tween2.chain().tween_property(panel, "position", Vector2(113+216.5,216.5), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween2.parallel()
	tween2.tween_property(button_play, "position", Vector2(76+216,161), 0.55).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween2.parallel()
	tween2.tween_property(settings, "position", Vector2(76+216,197), 0.6).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween2.parallel()
	tween2.tween_property(button_quit, "position", Vector2(76+216,197+36), 0.65).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
