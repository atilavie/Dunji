extends Sprite2D
const BOARD_HEIGHT = 16
const BOARD_WIDTH = 20
const CELL_WIDTH = 18

const TEXTURE_HOLDER = preload("res://Scenes/texture_holder.tscn")

const RED_BISHOP = preload("res://dunji_assets/red_bishop.png")
const RED_KING = preload("res://dunji_assets/red_king.png")
const RED_KNIGHT = preload("res://dunji_assets/red_knight.png")
const RED_PAWN = preload("res://dunji_assets/red_pawn.png")
const RED_QUEEN = preload("res://dunji_assets/red_queen.png")
const RED_ROOK = preload("res://dunji_assets/red_rook.png")
const RED_GENERAL = preload("res://dunji_assets/red_general.png")
const RED_SPY = preload("res://dunji_assets/red_spy.png")
const RED_MONK = preload("res://dunji_assets/red_monk.png")
const RED_SPEARMAN = preload("res://dunji_assets/red_spearman.png")
const RED_WALL = preload("res://dunji_assets/red_wall.png")
const RED_TOWER = preload("res://dunji_assets/red_tower.png")
const RED_CASTLE = preload("res://dunji_assets/red_castle.png")
const RED_CATAPULT = preload("res://dunji_assets/red_catapult.png")
const RED_RAM = preload("res://dunji_assets/red_ram.png")
const RED_CANNON = preload("res://dunji_assets/red_cannon.png")
const BLUE_BISHOP = preload("res://dunji_assets/blue_bishop.png")
const BLUE_KING = preload("res://dunji_assets/blue_king.png")
const BLUE_KNIGHT = preload("res://dunji_assets/blue_knight.png")
const BLUE_PAWN = preload("res://dunji_assets/blue_pawn.png")
const BLUE_QUEEN = preload("res://dunji_assets/blue_queen.png")
const BLUE_ROOK = preload("res://dunji_assets/blue_rook.png")
const BLUE_GENERAL = preload("res://dunji_assets/blue_general.png")
const BLUE_SPY = preload("res://dunji_assets/blue_spy.png")
const BLUE_MONK = preload("res://dunji_assets/blue_monk.png")
const BLUE_SPEARMAN = preload("res://dunji_assets/blue_spearman.png")
const BLUE_WALL = preload("res://dunji_assets/blue_wall.png")
const BLUE_TOWER = preload("res://dunji_assets/blue_tower.png")
const BLUE_CASTLE = preload("res://dunji_assets/blue_castle.png")
const BLUE_CATAPULT = preload("res://dunji_assets/blue_catapult.png")
const BLUE_RAM = preload("res://dunji_assets/blue_ram.png")
const BLUE_CANNON = preload("res://dunji_assets/blue_cannon.png")
const PIECE_SHADOW = preload("res://dunji_assets/piece_shadow.png")
const MOVE_EMPTY = preload("res://dunji_assets/move_empty.png")
const MOVE_SELECTED = preload("res://dunji_assets/move_selected.png")
const MOVE_OCCUPIED = preload("res://dunji_assets/move_occupied.png")
var TURN_MARKER = preload("res://dunji_assets/timer.png")

@onready var pieces = $Pieces
@onready var mouse = $Mouse
@onready var dots = $Dots
@onready var turn = $Turn
@onready var icon = $Blur
var dungeon_template : Array
var do_random_blue_moves = false
var do_random_red_moves = false
var board : Array
var blue : bool = true
var starting = false
var state : bool = false
var moves = []
var selected_piece : Vector2
var stage : int = 0
var selected_team_blue = true
var false_capture = false
var castle_use = false
var config = ConfigFile.new()
var loaded_save = 1
var move_from_team = 1
var administrator = false
var together = false
var move_from_id = 0

var is_click = false
var pieces_moving = []
var in_menu = false
func _ready():
	
	$"../Camera2D".rotation_degrees = 0 if GlobalOrientation.blue_perspective else 180
	var o = 1 if round($"../Camera2D".rotation_degrees) == 180 else -1
	dungeon_template.push_front([  1,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,-14,-15, -7])#	16: = WALL
	dungeon_template.push_front([  1,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,-16,-16, -9])#	15: = TOWER
	dungeon_template.push_front([  1,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -2, -2,-12])#	14: = CASTLE
	dungeon_template.push_front([  1,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -2, -2,-12])#	13: = SPEARMAN
	dungeon_template.push_front([  4, 13, 13,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,-11,-11, -3])#	12: = RAM
	dungeon_template.push_front([  4, 13, 13,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,-11,-11, -3])#	11: = MONK
	dungeon_template.push_front([ 10,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -6])#	10: = GENERAL
	dungeon_template.push_front([  5,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -8])#	9: = CATAPULT
	dungeon_template.push_front([  8,  0, 17,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -5])#	8: = SPY
	dungeon_template.push_front([  6,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,-10])#	7: = CANNON
	dungeon_template.push_front([  3, 11, 11,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,-13,-13, -4])#	6: = KING
	dungeon_template.push_front([  3, 11, 11,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,-13,-13, -4])#	5: = QUEEN
	dungeon_template.push_front([ 12,  2,  2,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -1, -1, -1])#	4: = ROOK
	dungeon_template.push_front([ 12,  2,  2,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -1, -1, -1])#	3: = BISHOP
	dungeon_template.push_front([  9, 16, 16,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -1, -1, -1])#	2: = KNIGHT
	dungeon_template.push_front([  7, 15, 14,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -1, -1, -1])#	1: = PAWN

	var err = config.load("res://config.cfg")
	if err == OK:
		if config.get_value("settings", "last_save") == null:
			config.set_value("settings", "last_save", 1)
			config.save("res://config.cfg")
			loaded_save = config.get_value("settings", "last_save")
		load_save(config.get_value("settings", "last_save"), true)
	$PieceBox2/Shadow4.position += -Vector2(o,o)
	$PieceBox/Shadow3.position += -Vector2(o,o)
	$DunjiBoardBottomLeft/BoardBLShad.position -= Vector2(o,o)
	$DunjiBoardBottomRight/BoardBRShad.position -= Vector2(o,o)
	$DunjiBoardTopRight/BoardTRShad.position -= Vector2(o,o)
	$DunjiBoardTopRight/BoardTRShad.position -= Vector2(o,o)
	enforce_turns()
	for q in range(16):
		for w in range(20):
			pieces_moving.append(Vector2(q,w))
	opening_animation()
func options_vis():
	var options_mask = $"../Camera2D/Control/BarMask"
	var options_bar = $"../Camera2D/Control/OptionsBar"
	options_bar.visible = true
	options_mask.visible = true
func opening_animation():
	var options_bar = $"../Camera2D/Control/OptionsBar"
	var board_top_right = $DunjiBoardTopRight
	var board_top_left = $DunjiBoardTopLeft
	var board_bottom_right = $DunjiBoardBottomRight
	var board_bottom_left = $DunjiBoardBottomLeft
	var admin_button = $"../Camera2D/Control/AdminButton"
	var rotation_button = $"../Camera2D/Control/RotationButton"
	var exit_button = $"../Camera2D/Control/Quit"
	var settings_button = $"../Camera2D/Control/Settings"
	var tween2 = create_tween()
	var board_timer = 1
	get_tree().create_timer(board_timer+0.5).timeout.connect(options_vis)
	tween2.tween_property(board_top_right, "position", Vector2(0,0), board_timer+0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween2.parallel()
	tween2.tween_property(board_top_left, "position", Vector2(0,0), board_timer+0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween2.parallel()
	tween2.tween_property(board_bottom_left, "position", Vector2(0,0), board_timer-0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween2.parallel()
	tween2.tween_property(board_bottom_right, "position", Vector2(0,0), board_timer).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween2.chain().tween_property(options_bar, "position", Vector2(options_bar.position.x,options_bar.position.y-18), board_timer).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	piece_distribution()
	await get_tree().create_timer(2).timeout
	var tween3 = create_tween()
	tween3.chain().tween_property(admin_button, "position", Vector2(admin_button.position.x,admin_button.position.y + 54), 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween3.parallel()
	tween3.tween_property(rotation_button, "position", Vector2(rotation_button.position.x,rotation_button.position.y + 54), 1.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween3.parallel()
	tween3.tween_property(settings_button, "position", Vector2(settings_button.position.x,settings_button.position.y + 54), 1.4).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween3.parallel()
	tween3.tween_property(exit_button, "position", Vector2(exit_button.position.x,exit_button.position.y + 54), 1.6).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	
func piece_distribution():
	var box1 = $PieceBox
	var box2 = $PieceBox2
	var tween = create_tween()
	tween.chain().tween_property(box1, "position", Vector2(box1.position.x+144,box1.position.y), 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.parallel()
	tween.tween_property(box2, "position", Vector2(box2.position.x-144,box2.position.y), 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	await get_tree().create_timer(1).timeout
	var randomizer_array = []
	for q in range(16):
		for w in range(20):
			randomizer_array.append(Vector2(q,w))
	randomizer_array.shuffle()
	var double = false
	for w in randomizer_array:
		var origin = Vector2(0 + randi() % 4,-5 + randi() % 2) if board[w.x][w.y] > 0 else Vector2(15 - randi() % 4,24 - randi() % 2)
		if board[w.x][w.y] != 0:
			piece_animation(origin, Vector2(w.x,w.y), board[w.x][w.y], true)
			double = !double
			if double:
				await get_tree().create_timer(0.05).timeout
	await get_tree().create_timer(1).timeout
	var tween2 = create_tween()
	tween2.chain().tween_property(box1, "position", Vector2(box1.position.x-144,box1.position.y), 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween2.parallel()
	tween2.tween_property(box2, "position", Vector2(box2.position.x+144,box2.position.y), 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	pieces_moving = []
@rpc("any_peer")
func remote_process():
	board = $"..".player_board
func _process(_delta: float) -> void:
	remote_process()
	$"..".player_board = board
	for child in mouse.get_children():
		child.queue_free()
	display_board()
	if !state || !is_click || move_from_id == 0: return
	var o = 1 if round($"../Camera2D".rotation_degrees) == 180 else -1
	var mouse_holder = TEXTURE_HOLDER.instantiate()
	var mouse_holder_shadow = TEXTURE_HOLDER.instantiate()
	mouse.add_child(mouse_holder_shadow)
	mouse.add_child(mouse_holder)
	mouse_holder.global_position = get_global_mouse_position()
	mouse_holder_shadow.global_position = Vector2(get_global_mouse_position().x - o, get_global_mouse_position().y - o)
	mouse_holder.modulate.a = 0.7
	mouse_holder_shadow.modulate.a = 0.7
	match_texture(move_from_id, mouse_holder)
	mouse_holder_shadow.texture = PIECE_SHADOW
	
func match_texture(piece_id, holder):
	match piece_id:
		-16: holder.texture = RED_WALL
		-15: holder.texture = RED_TOWER
		-14: holder.texture = RED_CASTLE
		-13: holder.texture = RED_SPEARMAN
		-12: holder.texture = RED_RAM
		-11: holder.texture = RED_MONK
		-10: holder.texture = RED_GENERAL
		-9: holder.texture = RED_CATAPULT
		-8: holder.texture = RED_SPY
		-7: holder.texture = RED_CANNON
		-6: holder.texture = RED_KING
		-5: holder.texture = RED_QUEEN
		-4: holder.texture = RED_ROOK
		-3: holder.texture = RED_BISHOP
		-2: holder.texture = RED_KNIGHT
		-1: holder.texture = RED_PAWN
		0: holder.texture = null
		17: holder.texture = TURN_MARKER
		16: holder.texture = BLUE_WALL
		15: holder.texture = BLUE_TOWER
		14: holder.texture = BLUE_CASTLE
		13: holder.texture = BLUE_SPEARMAN
		12: holder.texture = BLUE_RAM
		11: holder.texture = BLUE_MONK
		10: holder.texture = BLUE_GENERAL
		9: holder.texture = BLUE_CATAPULT
		8: holder.texture = BLUE_SPY
		7: holder.texture = BLUE_CANNON
		6: holder.texture = BLUE_KING
		5: holder.texture = BLUE_QUEEN
		4: holder.texture = BLUE_ROOK
		3: holder.texture = BLUE_BISHOP
		2: holder.texture = BLUE_KNIGHT
		1: holder.texture = BLUE_PAWN
func _input(event):
	if event.is_action_pressed("Click"):
		is_click = true
		var var1 = snapped(get_global_mouse_position().x, 0) / CELL_WIDTH
		var var2 = abs(snapped(get_global_mouse_position().y, 0)) / CELL_WIDTH
		if is_mouse_out(): return
		if !state && ((blue && board[var2][var1] > 0) || (!blue && board[var2][var1] < 0) || board[var2][var1] == 17 || (administrator && !(board[var2][var1] ==0))):
			selected_piece = Vector2(var2, var1)
			move_from_id = get_board(selected_piece)
			show_options()
			state = true
			return
		elif state:
			var1 = snapped(get_global_mouse_position().x, 0) / CELL_WIDTH
			var2 = abs(snapped(get_global_mouse_position().y, 0)) / CELL_WIDTH
			set_move(var2, var1)
			return
	if event.is_action_released("Click"):
		if !state: return
		is_click = false
		if is_mouse_out(): return
		var var1 = snapped(get_global_mouse_position().x, 0) / CELL_WIDTH
		var var2 = abs(snapped(get_global_mouse_position().y, 0)) / CELL_WIDTH
		if selected_piece.x == var2 && selected_piece.y == var1: 
			return
		set_move(var2, var1)
	if event.is_action_pressed("Reload"):
		load_save(loaded_save, false)
		delete_dots()
		state = false
	if event.is_action_pressed("Load 1"):
		load_save(1, false)
		delete_dots()
		state = false
	if event.is_action_pressed("Load 2"):
		load_save(2, false)
		delete_dots()
		state = false
	if event.is_action_pressed("Load 3"):
		load_save(3, false)
		delete_dots()
		state = false
	if event.is_action_pressed("Load 4"):
		load_save(4, false)
		delete_dots()
		state = false
	if event.is_action_pressed("Load 5"):
		load_save(5, false)
		delete_dots()
		state = false
	if event.is_action_pressed("Load 6"):
		load_save(6, false)
		delete_dots()
		state = false
	if event.is_action_pressed("Load 7"):
		load_save(7, false)
		delete_dots()
		state = false
	if event.is_action_pressed("Load 8"):
		load_save(8, false)
		delete_dots()
		state = false
	if event.is_action_pressed("Load 9"):
		load_save(9, false)
		delete_dots()
		state = false
	if event.is_action_pressed("Save"):
		for x in range(20):
			board_sort()
		save(loaded_save)
	if event.is_action_pressed("Admin"):
		_on_check_button_button_up()
	if event.is_action_pressed("ui_left"):
		do_random_red_moves = !do_random_red_moves
	if event.is_action_pressed("ui_right"):
		do_random_blue_moves = !do_random_blue_moves
func do_random_move():
	if !do_random_blue_moves && blue: return
	if !do_random_red_moves && !blue: return
	var my_pieces = []
	for q in range(16):
		for w in range(20):
			if ((board[q][w] > 0) if blue else (board[q][w] < 0)) && board[q][w] != 17:
				my_pieces.append(Vector2(q,w))
	for x in range(100):
		my_pieces.shuffle()
		selected_piece = my_pieces[0]
		var my_moves = get_moves(selected_piece)
		my_moves.shuffle()
		if my_moves.size() == 0:
			continue
		else:
			var chosen_move = my_moves[0]
			show_options()
			state = true
			set_move(chosen_move.x,chosen_move.y)
			break
func save(save_value):
	config.set_value("saves", str(save_value), board_to_fen(board))
	config.set_value("settings", "rotation", GlobalOrientation.blue_perspective)
	config.set_value("settings", "last_save", GlobalOrientation.loaded_save)
	config.save("res://config.cfg")
	loaded_save = save_value
func load_save(save_value, is_opening : bool):
	var err = config.load("res://config.cfg")
	var previous_board = board
	if err == OK:
		$"../Camera2D/Control/RotationButton".button_pressed = !config.get_value("settings", "rotation")
		GlobalOrientation.blue_perspective = config.get_value("settings", "rotation")
		GlobalOrientation.loaded_save = config.get_value("settings", "last_save")
		if !(config.get_value("saves", str(save_value)) == null):
			board = fen_to_board(config.get_value("saves", str(save_value)))
			loaded_save = save_value
		else:
			config.set_value("saves", str(save_value), board_to_fen(dungeon_template))
			board = fen_to_board(config.get_value("saves", str(save_value)))
			loaded_save = save_value
		config.set_value("settings", "last_save", save_value)
		config.save("res://config.cfg")
	else: board = dungeon_template
	$"..".player_board = board
	enforce_turns()
	if is_opening: return
	var from_board_array = []
	var to_board_array = []
	for q in range(16):
		for w in range(20):
			if previous_board[q][w] != board[q][w]:
				from_board_array.append(Vector2(q,w))
				to_board_array.append(Vector2(q,w))
	for g in to_board_array:
		var origin = Vector2(0,0)
		for w in from_board_array:
			if previous_board[w.x][w.y] == board[g.x][g.y]:
				from_board_array.erase(w)
				origin = w
				break
		piece_animation(origin, g, board[g.x][g.y], false)
func board_to_fen(board_input) -> String:
	var fen_output = ''
	for c in range(0, 16):
		var spaces = 0
		for b in range(0, 20):
			var z = str(fen_sort(board_input[c][b]))
			if z == '1':
				spaces += 1
			else:
				if spaces > 0:
					fen_output += str(spaces)
					spaces = 0
				fen_output += z 
		if spaces > 0:
			fen_output += str(spaces)
		if c != 15:
			fen_output += '/'
	return fen_output
func fen_sort(g : int) -> String:
	match (g):
		1 : return 'P'
		2 : return 'N'
		3 : return 'B'
		4 : return 'R'
		5 : return 'Q'
		6 : return 'K'
		7 : return 'C' 
		8 : return 'S'
		9 : return 'A' 
		10: return 'G'
		11: return 'M' 
		12: return 'X' 
		13: return 'E' 
		14: return 'L'
		15: return 'T'
		16: return 'W'
		-1 : return 'p' 
		-2 : return 'n' 
		-3 : return 'b'
		-4 : return 'r'
		-5 : return 'q'
		-6 : return 'k'
		-7 : return 'c' 
		-8 : return 's'
		-9 : return 'a' 
		-10: return 'g'
		-11: return 'm' 
		-12: return 'x' 
		-13: return 'e' 
		-14: return 'l'
		-15: return 't'
		-16: return 'w'
		17: return '+'
		_: return '1'
func fen_to_board(fen_input: String) -> Array:
	var board_output = []
	var rows = fen_input.split("/")
	for row in rows:
		var board_row = []
		var i = 0
		while i < row.length():
			var charactar = row[i]
			if charactar.is_valid_int():
				var num_str = ""
				while i < row.length() and row[i].is_valid_int():
					num_str += row[i]
					i += 1
				var spaces = int(num_str)
				for a in range(spaces):
					board_row.append(0)
				continue
			else:
				board_row.append(fen_to_value(charactar))
				i += 1
		board_output.append(board_row)
	return board_output
func fen_to_value(fen_char: String) -> int:
	match fen_char:
		'P': return 1
		'N': return 2
		'B': return 3
		'R': return 4
		'Q': return 5
		'K': return 6
		'C': return 7
		'S': return 8
		'A': return 9
		'G': return 10
		'M': return 11
		'X': return 12
		'E': return 13
		'L': return 14
		'T': return 15
		'W': return 16
		'p': return -1
		'n': return -2
		'b': return -3
		'r': return -4
		'q': return -5
		'k': return -6
		'c': return -7
		's': return -8
		'a': return -9
		'g': return -10
		'm': return -11
		'x': return -12
		'e': return -13
		'l': return -14
		't': return -15
		'w': return -16
		'+': return 17
		_: return 0
func is_mouse_out():
	move_from_id = 0
	if get_global_mouse_position().x < 0: return true
	if get_global_mouse_position().y > 0: return true
	if get_global_mouse_position().x > 359: return true
	if get_global_mouse_position().y < -287: return true
	return false

func display_board():
	$"../Camera2D".rotation_degrees = 0 if GlobalOrientation.blue_perspective else 180
	var o = 1 if round($"../Camera2D".rotation_degrees) == 180 else -1
	for child in pieces.get_children():
		child.queue_free()
	for i in BOARD_HEIGHT:
		for j in BOARD_WIDTH:
			if pieces_moving.has(Vector2(i, j)):
				continue
			piece_texture_assign(i, j, o)
func piece_texture_assign(i, j, o):
	var holder = TEXTURE_HOLDER.instantiate()
	var holder_shadow = TEXTURE_HOLDER.instantiate()
	pieces.add_child(holder_shadow)
	pieces.add_child(holder)
	holder_shadow.position = Vector2((j * CELL_WIDTH + (CELL_WIDTH / 2)) - o, (-i * CELL_WIDTH - (CELL_WIDTH / 2)) - o)
	holder.position = Vector2((j * CELL_WIDTH + (CELL_WIDTH / 2)), (-i * CELL_WIDTH - (CELL_WIDTH / 2)))
	if board[i][j] != 0:
		holder_shadow.texture = PIECE_SHADOW
	match_texture(board[i][j], holder)

func match_sort(g : int):
	match abs(g):
		1 : return 16
		2 : return 15
		3 : return 8
		4 : return 7
		5 : return 6
		6 : return 1
		7 : return 10
		8 : return 5
		9 : return 11
		10: return 9
		11: return 13
		12: return 12
		13: return 14
		14: return 2
		15: return 3
		16: return 4
		_: return 18
func show_options():
	moves = get_moves(selected_piece)
	if moves == []:
		state = false
		return
	show_dots()
func show_dots():
	for i in moves:
		if get_board(i) != 0:
			var holder = TEXTURE_HOLDER.instantiate()
			dots.add_child(holder)
			holder.texture = MOVE_OCCUPIED
			holder.position = Vector2(i.y * CELL_WIDTH + (CELL_WIDTH / 2), -i.x * CELL_WIDTH - (CELL_WIDTH / 2))
		else:
			var holder = TEXTURE_HOLDER.instantiate()
			dots.add_child(holder)
			holder.texture = MOVE_EMPTY
			holder.position = Vector2(i.y * CELL_WIDTH + (CELL_WIDTH / 2), -i.x * CELL_WIDTH - (CELL_WIDTH / 2))
	if get_board(selected_piece) != 0:
		var turn_selected_holder = TEXTURE_HOLDER.instantiate()
		dots.add_child(turn_selected_holder)
		turn_selected_holder.texture = MOVE_SELECTED
		turn_selected_holder.position = Vector2(selected_piece.y * CELL_WIDTH + (CELL_WIDTH / 2), -selected_piece.x * CELL_WIDTH - (CELL_WIDTH / 2))
func delete_dots():
	for child in dots.get_children():
		child.queue_free()
func enforce_turns():
	if board[7][2] == 17:
		blue = true
		stage = 0
	if board[8][2] == 17:
		blue = false
		stage = 0
	if board[7][17] == 17:
		blue = true
		stage = 1
	if board[8][17] == 17:
		blue = false
		stage = 1
func set_move(var2, var1):
	if var2 > 15 or var1 > 20: return
	var move_to_space = Vector2(var2, var1)
	var move_to_id = board[var2][var1]
	var move_from_space = selected_piece
	move_from_id = get_board(move_from_space)
	var has_moved = false
	move_from_team = 1 if (move_from_id > 0) else -1
	selected_team_blue = false if move_from_id > 0 else true if move_from_id < 0 else selected_team_blue
	for i in moves:
		if i.x == var2 && i.y == var1:
			move_behavior(move_from_space, move_to_space, move_to_id, i, var1, var2)
			has_moved = true
			break
	$MoveTimer.start()
	delete_dots()
	enforce_turns()
	get_result()
	state = false
	false_capture = false
	if !(move_from_id * move_from_team > 0):
		return
	if !administrator && !(board[var2][var1] == 17) && !has_moved && ((blue && move_to_id > 0) || (!blue && move_to_id < 0)):
		selected_piece = Vector2(var2, var1)
		move_from_id = board[var2][var1]
		if !(dungeon(move_from_space) && stage == 1):
			show_options()
			state = true
func piece_animation(from_space, to_space, piece_id, tween_in : bool):
	if piece_id == 0 || null:
		return
	var new_piece = Sprite2D.new()
	var shadow = Sprite2D.new()
	var o = 1 if round($"../Camera2D".rotation_degrees) == 180 else -1
	var move_time = 0.6
	pieces_moving.append(to_space)
	icon.add_child(new_piece)
	new_piece.add_child(shadow)
	shadow.position.x -= o
	shadow.position.y -= o
	new_piece.z_index = 3
	shadow.z_index = -1
	shadow.texture = preload("res://dunji_assets/piece_shadow.png")
	match_texture(piece_id, new_piece)
	new_piece.visible = true
	var tween = create_tween()
	new_piece.position = Vector2(from_space.y * 18 + 9,from_space.x * -18 -9)
	var move_time_bonus = 0.2
	if tween_in:
		new_piece.scale = Vector2(0,0)
		tween.tween_property(new_piece, "scale", Vector2(1,1), 0.25)
		move_time_bonus += 0.25
	tween.chain().tween_property(new_piece, "scale", Vector2(1.2,1.2), 0.1)
	tween.chain().tween_property(new_piece, "position", Vector2(to_space.y * 18 + 9,to_space.x * -18 - 9), move_time).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.chain().tween_property(new_piece, "scale", Vector2(1,1), 0.1)
	await get_tree().create_timer(move_time-0.2).timeout
	$AudioStreamPlayer2D.play()
	await get_tree().create_timer(move_time_bonus+0.2).timeout
	new_piece.queue_free()
	pieces_moving.erase(to_space)
	pieces_moving.erase(to_space)
func move_behavior(move_from_space, move_to_space, move_to_id, i, var1, var2):
	var f = 13 if blue else 2
	if !administrator:
		special_behavior(move_from_space, move_to_space, move_to_id, i, var1, var2)
	if false_capture:
		if move_from_id == get_board(move_from_space):
			set_board(move_from_space, 0)
		if castle_use:
			castle_store(move_from_space, move_from_id)
	else:
		set_board(move_to_space, move_from_id)
		if !(move_from_id == move_from_team && move_to_space.x == f) || has_candidates():
			piece_animation(move_from_space, move_to_space, move_from_id, false)
		if move_from_id == get_board(move_from_space):
			set_board(move_from_space, 0)
	if !has_candidates() && !administrator:
		for x in range(0,12):
			if board[f][x+4] == move_from_team:
				dungeon_capture(board[f][x+4],Vector2(f-move_from_team,x+4))
				set_board(Vector2(f,x+4),0)
		blue = !blue
		for w in [2, 17]:
			board[7][w] += board[8][w]
			board[8][w] = board[7][w] - board[8][w]
			board[7][w] -= board[8][w]
			if board[7][w] != 0:
				piece_animation(Vector2(8,w), Vector2(7,w), 17, false)
			elif board[8][w] != 0:
				piece_animation(Vector2(7,w), Vector2(8,w), 17, false)
	if !(is_empty(move_to_space) || false_capture || together):
		dungeon_capture(move_to_id,move_to_space)
	if stage == 0:
		placement_end()
func special_behavior(move_from_space, move_to_space, move_to_id, i, var1, var2):
	match abs(move_from_id):
		10:
			if move_to_id == (2 * move_from_team):
				together = true
			move_with(move_from_space, move_to_space, (2 * move_from_team))
		11:
			if !((move_to_id * move_from_team) > 0):
				dungeon_fetch(move_to_id, false, move_from_space)
		3:
			if !((move_to_id * move_from_team) > 0):
				dungeon_fetch(move_to_id, false, move_from_space)
			if (move_to_id * move_from_team) == 11:
				together = true
			move_with(move_from_space, move_to_space, 11 * move_from_team)
	false_capture = false
	var destinations = [Vector2(1,0), Vector2(3,0), Vector2(2,0)]
	if board[var2][var1] == (7 * move_from_team):
		dungeon_capture(move_from_id, move_from_space)
		for r in destinations:
			if battlefield(i+(r * move_from_team)):
				dungeon_capture(board[var2 + (r.x * move_from_team)][var1],Vector2(var2 + (r.x * move_from_team),var1))
		for r in destinations:
			var converters = [3,11]
			if battlefield(i+(r * move_from_team)):
				if !((board[var2 + (r.x * move_from_team)][var1] * move_from_team) > 0):
					if converters.has(move_from_id):
						print("hi")
						dungeon_fetch(board[var2 + (r.x * move_from_team)][var1], false, move_from_space)
				board[var2 + (r.x * move_from_team)][var1] = 0
		set_board(move_to_space, 7 * move_from_team)
		false_capture = true
	elif (board[var2][var1] == (14 * move_from_team)):
		set_board(move_to_space, 14 * move_from_team)
		false_capture = true
		castle_use = true
func get_moves(selected : Vector2):
	var _moves = []
	move_from_team = 1 if (get_board(selected) > 0) else -1
	if get_board(selected) > 0:
		selected_team_blue = true
	elif get_board(selected) < 0:
		selected_team_blue = false
	if !administrator:
		if blue && move_from_team == -1:
			return _moves
		if !blue && move_from_team == 1:
			return _moves
	if administrator && !(get_board(selected) == 17):
		_moves = []
		admin_placement(selected, _moves)
		return _moves
	if stage == 0 && !(get_board(selected) == 17):
		_moves = []
		if dungeon(selected) && is_dungeon_space():
			opening_placement(selected, _moves)
		elif dungeon(selected) && abs(get_board(selected)) == 14:
			opening_placement(selected, _moves)
	if stage == 1:
		if castle(selected):
			placement(selected, _moves)
		if has_candidates():
			_moves = []
			if dungeon(selected):
				promotion(selected, _moves)
	if (!king_in_castle() || ((selected.x < 6) && blue) || ((selected.x > 9) && !blue)) && ((battlefield(selected) && stage == 1)):
		match abs(get_board(selected)):
			1: _moves = get_pawn_moves(selected)
			2: _moves = get_knight_moves(selected)
			3: _moves = get_bishop_moves(selected)
			4: _moves = get_rook_moves(selected)
			5: _moves = get_queen_moves(selected)
			6: _moves = get_king_moves(selected)
			7: _moves = get_cannon_moves(selected)
			8: _moves = get_spy_moves(selected)
			9: _moves = get_catapult_moves(selected)
			10: _moves = get_general_moves(selected)
			11: _moves = get_monk_moves(selected)
			12: _moves = get_ram_moves(selected)
			13: _moves = get_spearman_moves(selected)
	if (administrator && is_board(selected, 17)):
		_moves = turn_marker_moves(selected)
	moves_cull(_moves)
	return _moves
func moves_cull(_moves):
	_moves.sort()
	for i in range(0, _moves.size()):
		if i < _moves.size()-1 && (_moves[i] == _moves[i+1]):
			_moves.remove_at(i)
func board_sort():
	for i in range(0, 10):
		for n in range(4, 15):
			var castle_pos = Vector2(0, n)
			var castle1 = board[castle_pos.x][castle_pos.y]
			var castle2 = board[castle_pos.x][castle_pos.y + 1]
			if match_sort(castle1) > match_sort(castle2):
				board[castle_pos.x][castle_pos.y + 1] = castle1
				board[castle_pos.x][castle_pos.y] = castle2
		for n in range(11):
			var castle_pos = Vector2(15, -n - 5)
			var castle1 = board[castle_pos.x][castle_pos.y]
			var castle2 = board[castle_pos.x][castle_pos.y - 1]
			if match_sort(castle1) > match_sort(castle2):
				board[castle_pos.x][castle_pos.y - 1] = castle1
				board[castle_pos.x][castle_pos.y] = castle2
	for i in range(0, 15 * 20):
		var a = i / 20
		var c = i % 20
		for b in range(20):
			if dungeon_template[a][b] == board[a + 1][c] and board[a][b] == 0 and dungeon(Vector2(a + 1, c)) and board[a + 1][c] > 0:
				board[a][b] = dungeon_template[a][b]
				board[a + 1][c] = 0
				break
			if board[a][b] == dungeon_template[a + 1][c] and board[a + 1][c] == 0 and dungeon(Vector2(a, b)) and board[a][b] < 0:
				board[a][b] = 0
				board[a + 1][c] = dungeon_template[a][b]
				break
	for i in range(0, 16 * 20): 
		var a = i / 20 
		var b = i % 20  
		if b > 0: 
			if dungeon_template[a][b] == board[a][b - 1] and board[a][b] == 0 and not battlefield(Vector2(a, b - 1)) and board[a][b - 1] > 0:
				board[a][b] = dungeon_template[a][b]
				board[a][b - 1] = 0
			elif dungeon_template[a][b - 1] == board[a][b] and board[a][b - 1] == 0 and not battlefield(Vector2(a, b - 1)) and board[a][b] < 0:
				board[a][b] = 0
				board[a][b - 1] = dungeon_template[a][b]
func opening_placement(selected: Vector2, _moves):
	var pos = Vector2(0, 0)
	if not dungeon(selected):
		return
	for index in range(2 * 20 + 4, 14 * 20 + 16):
		var c = index / 20
		var b = index % 20
		if c < 2 or c > 13 or b < 4 or b > 15:
			continue
		pos = Vector2(c, b)
		if battlefield(pos) and is_empty(pos) and ((pos.x < 6 and blue) || (pos.x > 9 and not blue)):
			_moves.append(pos)
func placement_end():
	var piece_locations = []
	var pos = Vector2(0, 0)
	for c in range(0,16):
		for b in range(0, 20):
			pos = Vector2(c, b)
			if dungeon(pos) && board[c][b] != 0:
				piece_locations.append(pos)
	if piece_locations.size() == 24:
		for g in piece_locations:
			if has_castle_room:
				castle_store(g, board[g.x][g.y])
				board[g.x][g.y] = 0
		board[7][17] = 17
		board[7][2] = 0
func placement(selected: Vector2, _moves):
	var directions = [Vector2(0, 1), Vector2(0, -1), Vector2(1, 0), Vector2(-1, 0),
		Vector2(1, 1), Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1)]
	if !castle(selected):
		return
	for index in range(2 * 20 + 4, 14 * 20 + 16):
		var c = index / 20
		var b = index % 20
		if c < 2 or c > 13 or b < 4 or b > 15:
			continue
		var pos = Vector2(c, b)
		if not is_empty(pos):
			continue
		for direction in directions:
			var place_helper = [5, 14, 15, 16]
			var place_check = pos + direction
			if place_helper.has(move_from_team * get_board(place_check)):
				_moves.append(pos)
func promotion(selected: Vector2, _moves):
	var pos = Vector2(0, 0)
	var c = null
	if dungeon(selected):
		c = 13 if blue else 2
	else: return
	for b in range(4,16):
		pos = Vector2(c, b)
		if battlefield(pos) && is_board(pos, 1) && !is_board(selected, 1): 
			_moves.append(pos)
func has_candidates():
	var pos = Vector2(0, 0)
	var candidates = []
	var can_promote = false
	for index in range(0, 16 * 20):
		var c = index / 20
		var b = index % 20
		if blue and b >= 4:
			continue
		if not blue and b < 16:
			continue
		pos = Vector2(c, b)
		if dungeon(pos) and not is_empty(pos) and not is_board(pos, 1):
			candidates.append(pos)
	var v = 13 if blue else 2
	for b in range(4,16):
		pos = Vector2(v, b)
		if battlefield(pos) && is_board(pos, 1):
			can_promote = true
	if (candidates.size() > 0) && can_promote:
		return true
	return false
func admin_placement(selected: Vector2, _moves):
	var pos = Vector2(0, 0)
	for i in range(0, 320):
		var c = i / 20
		var b = i % 20
		pos = Vector2(c, b)
		if (battlefield(pos) || (!dungeon(selected) && dungeon(pos) && is_empty(pos) && (get_board(selected) == dungeon_template[pos.x][pos.y])) || castle(pos)) && selected != pos: 
			_moves.append(pos)
func battlefield(pos):
	if pos.x > 1 && pos.y < 16 && pos.y > 3 && pos.x < 14: return true
	return false
func dungeon(pos):
	if pos.y < 3 && pos.x < 6 && pos.y > -1 && pos.x > -1: return true 
	if pos.y < 3 && pos.x > 9 && pos.y > -1 && pos.x < 16: return true 
	if pos.y == 0 && pos.x > 5 && pos.x < 10: return true 
	if pos.y < 20 && pos.x < 6 && pos.y > 16 && pos.x > -1: return true 
	if pos.y < 20 && pos.x > 9 && pos.y > 16 && pos.x < 16: return true 
	if pos.y == 19 && pos.x > 5 && pos.x < 10: return true 
	return false
func castle(pos):
	if !((pos.x == 0 && selected_team_blue) || (pos.x == 15 && !selected_team_blue)):
		return false
	if pos.y >= 4 && pos.y <= 15:
		return true
	return false
func has_castle_room():
	var f = 0
	if !selected_team_blue:
		f = 15
	for d in range(4,16):
		if is_empty(Vector2(f,d)): return true
	return false
func dungeon_fetch(move_to_id_enemy, same_capture, move_from_space):
	if move_to_id_enemy == 0: return
	var success = false
	var target = move_from_team
	var looped = false
	var i = 0
	if abs(move_to_id_enemy) > 1:
		target = -move_to_id_enemy
	var empty_castle_space = Vector2(0, 0)
	for n in range(4 if blue else -15, 16 if blue else -3):
		var castle_pos = Vector2(0 if (move_from_team == 1) else 15, n if (move_from_team == 1) else -n)
		if is_empty(castle_pos):
			empty_castle_space = castle_pos
	if empty_castle_space == Vector2(0, 0): return
	if (move_from_team == 1 && board[0][2] == 14) || (move_from_team == -1 && board[15][17] == -14): return
	while i < 320:
		var g = i / 20
		var r = i % 20
		var candidate_space = Vector2(g, r)
		if same_capture:
			candidate_space = move_from_space
		var target_piece = get_board(candidate_space)
		if dungeon(candidate_space) && !success && target_piece == target:
			set_board(candidate_space, 0)
			castle_store(candidate_space, target_piece)
			success = true
		if success: return
		if i == 319 && !looped:
			i = 0
			target = move_from_team
			looped = true
		else: i += 1
func dungeon_capture(piece, from_space):
	var success = false
	if piece > 0:
		for r in range(16):
			for g in range(-19, 1):
				if dungeon_template[r][-g] == piece && !success && board[r][-g] == 0:
					board[r][-g] = piece
					piece_animation(from_space, Vector2(r,-g), piece, false)
					success = true
	else:
		for r in range(-15,1):
			for g in range(20):
				if dungeon_template[-r][g] == piece && !success && board[-r][g] == 0:
					board[-r][g] = piece
					piece_animation(from_space, Vector2(-r,g), piece, false)
					success = true
	if piece == 14:
		selected_team_blue = true
	elif piece == -14:
		selected_team_blue = false
	else: return
	for i in range(0, 320):
		var g = i / 20
		var r = i % 20
		if castle(Vector2(g,r)):
			var piece_extract = board[g][r]
			board[g][r] = 0
			dungeon_capture(piece_extract, Vector2(g,r))
func is_dungeon_space():
	for g in range(0, 16):
		for r in range(0 if blue else 9, 9 if blue else 20):
			if dungeon(Vector2(g,r)) && board[g][r] == 0: return true
	return false
func castle_store(from_space, piece):
	for n in range(4 if (piece>0) else -15, 16 if (piece>0) else -3):
		var castle_pos = Vector2(0 if (piece>0) else 15, n if (piece>0) else -n)
		if is_empty(castle_pos):
			board[castle_pos.x][castle_pos.y] = piece
			piece_animation(from_space, castle_pos, piece, false)
			break
func move_with(move_from_space, move_to_space, follower):
	var directions = [Vector2(0, 1), Vector2(0, -1), Vector2(1, 0), Vector2(-1, 0), Vector2(1, 1), Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1)]
	var comrades = []
	var comrades_bring = []
	var comrades_leave = []
	for h in directions:
		var comrade_test = move_from_space + h
		if battlefield(comrade_test) && board[comrade_test.x][comrade_test.y] == follower:
			comrades.append(h)
	for t in comrades:
		var comrades_remove = move_from_space + t
		board[comrades_remove.x][comrades_remove.y] = 0
	for g in comrades:
		var comrades_destination = move_to_space + g
		if !battlefield(comrades_destination):
			comrades_leave.append(g)
			continue
		if is_empty(comrades_destination) || (get_board(comrades_destination) == get_board(move_from_space)):
			comrades_bring.append(g)
		else: comrades_leave.append(g)
	for l in comrades_bring:
		set_board(move_to_space + l, follower)
		piece_animation(move_from_space + l, move_to_space + l, follower, false)
	for u in comrades_leave:
		set_board(move_from_space + u, follower)
func exception_handler(pos, _moves, piece_position):
	if is_board(pos, 7):
		_moves.append(pos)
	elif is_board(pos, 9):
		var direction
		direction = [Vector2(1, 1), Vector2(1, -1), Vector2(2, 2), Vector2(2, -2), Vector2(3, 3), Vector2(3, -3)]
		for n in direction:
			if battlefield(pos + (n * move_from_team)) && ((pos + (n * move_from_team)) != piece_position):
				_moves.append(pos + n * move_from_team)
				exception_handler(pos + n * move_from_team, _moves, piece_position)
	elif is_board(pos, 14):
		for n in range(4, 16):
			var castle_pos = Vector2(0 if blue else 15, n)
			if is_empty(castle_pos):
				_moves.append(pos)
				break
	elif is_board(pos, 15):
		var direction = [Vector2(0, 1), Vector2(0, -1), Vector2(1, 0), Vector2(-1, 0), Vector2(1, 1), Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1)]
		for r in direction:
			var check = pos + r
			for k in direction:
				if check == piece_position + k && battlefield(piece_position + k) && battlefield(piece_position + 2 * k) && (is_empty(piece_position + 2 * k)) && is_child(piece_position, piece_position + k):
					_moves.append(piece_position + k)
			if (is_enemy(check) || is_empty(check)) && battlefield(check):
				_moves.append(check)
			else: exception_handler(check, _moves, piece_position)
func is_child(pos1, pos2):
	if get_board(pos1) == (3 * move_from_team) && get_board(pos2) == (11 * move_from_team):
		return true
	if get_board(pos1) == (10 * move_from_team) && get_board(pos2) == (2 * move_from_team):
		return true
	return false
func king_in_castle():
	for n in range(4 if blue else -15, 16 if blue else -3):
		var castle_pos = Vector2(0 if blue else 15, n if blue else -n)
		if board[castle_pos.x][castle_pos.y] == (6 if blue else -6): return true
	return false
func get_board(get_pos):
	var output = board[get_pos.x][get_pos.y]
	return output
func set_board(get_pos, piece_id):
	board[get_pos.x][get_pos.y] = piece_id
func get_pawn_moves(piece_position : Vector2):
	var _moves = []
	var direction
	var pos
	if blue: direction = Vector2(1, 0)
	else: direction = Vector2(-1, 0)
	for movement_range in range(3):
		pos = piece_position + direction * movement_range
		if battlefield(pos) and (movement_range == 1 or home_ranks(piece_position) and is_empty(piece_position + direction)):
			if is_empty(pos):
				_moves.append(pos)
			else:
				exception_handler(pos, _moves, piece_position)
	for y_offset in [1, -1]:
		pos = piece_position + Vector2(direction.x, y_offset)
		if battlefield(pos) && is_enemy(pos):
			_moves.append(pos)
	return _moves
func get_knight_moves(piece_position : Vector2):
	var movement_pattern = "knight"
	var building_capture = false
	var companion = 0
	var movement_range = 1
	var infiltrator = false
	return movement(movement_pattern, building_capture, piece_position, companion, movement_range, infiltrator)
func get_bishop_moves(piece_position : Vector2):
	var movement_pattern = "diagonal"
	var building_capture = false
	var companion = 11
	var movement_range = -1
	var infiltrator = false
	return movement(movement_pattern, building_capture, piece_position, companion, movement_range, infiltrator)
func get_rook_moves(piece_position : Vector2):
	var movement_pattern = "straight"
	var building_capture = false
	var companion = 0
	var movement_range = -1
	var infiltrator = false
	return movement(movement_pattern, building_capture, piece_position, companion, movement_range, infiltrator)
func get_queen_moves(piece_position : Vector2):
	var movement_pattern = "straight, diagonal"
	var building_capture = false
	var companion = 0
	var movement_range = 1
	var infiltrator = false
	return movement(movement_pattern, building_capture, piece_position, companion, movement_range, infiltrator)
func get_king_moves(piece_position : Vector2):
	var movement_pattern = "straight, diagonal"
	var building_capture = false
	var companion = 0
	var movement_range = 1
	var infiltrator = false
	return movement(movement_pattern, building_capture, piece_position, companion, movement_range, infiltrator)
func get_cannon_moves(piece_position : Vector2):
	var movement_pattern = "straight"
	var building_capture = true
	var companion = 0
	var movement_range = 1
	var infiltrator = false
	return movement(movement_pattern, building_capture, piece_position, companion, movement_range, infiltrator)
func get_spy_moves(piece_position : Vector2):
	var movement_pattern = "straight, diagonal"
	var building_capture = false
	var companion = 0
	var movement_range = -1
	var infiltrator = true
	return movement(movement_pattern, building_capture, piece_position, companion, movement_range, infiltrator)
func get_catapult_moves(piece_position : Vector2):
	var movement_pattern = "straight"
	var building_capture = true
	var companion = 0
	var movement_range = 1
	var infiltrator = false
	return movement(movement_pattern, building_capture, piece_position, companion, movement_range, infiltrator)
func get_general_moves(piece_position : Vector2):
	var movement_pattern = "straight, diagonal, knight"
	var building_capture = true
	var companion = 2
	var movement_range = 1
	var infiltrator = false
	return movement(movement_pattern, building_capture, piece_position, companion, movement_range, infiltrator)
func get_monk_moves(piece_position : Vector2):
	var movement_pattern = "diagonal"
	var building_capture = false
	var companion = 0
	var movement_range = 2
	var infiltrator = false
	return movement(movement_pattern, building_capture, piece_position, companion, movement_range, infiltrator)
func get_ram_moves(piece_position : Vector2):
	var movement_pattern = "straight, diagonal"
	var building_capture = true
	var companion = 0
	var movement_range = 1
	var infiltrator = false
	return movement(movement_pattern, building_capture, piece_position, companion, movement_range, infiltrator)
func get_spearman_moves(piece_position : Vector2):
	var movement_pattern = "straight"
	var building_capture = false
	var companion = 0
	var movement_range = 2
	var infiltrator = false
	return movement(movement_pattern, building_capture, piece_position, companion, movement_range, infiltrator)
func turn_marker_moves(piece_position : Vector2):
	var _moves = []
	if !administrator: return _moves
	var directions = [Vector2(7, 2), Vector2(8, 2), Vector2(7, 17), Vector2(8, 17)]
	for i in directions:
		var pos = i
		if pos != piece_position:
			_moves.append(pos)
	return _moves
func is_empty(pos : Vector2):
	if (pos.x <= 15 && pos.x >= 0) && (pos.y <= 20 && pos.y >= 0):
		if get_board(pos) == 0: return true
	return false
func is_enemy(pos : Vector2):
	if blue && get_board(pos) in range(-13,0) || !blue && get_board(pos) in range(1,14): return true
	return false
func is_enemy_incl(pos : Vector2):
	if blue && get_board(pos) < 0 || !blue && get_board(pos) > 0: return true
	return false
func get_result():
	if is_conquest_victory():
		if blue:
			print("Red WINS by Conquest Victory")
		else:
			print("Blue WINS by Conquest Victory")
	if is_pilgrimage_victory():
		if blue:
			print("Red WINS by Pilgrimage Victory")
		else:
			print("Blue WINS by Pilgrimage Victory")
	if is_resignation_victory():
		if !blue:
			print("Red WINS by Resignation Victory")
		else:
			print("Blue WINS by Resignation Victory")
func is_conquest_victory():
	if board[6][0] == 6:
		return true
	if board[9][19] == -6:
		return true
	return false
func is_pilgrimage_victory():
	for j in BOARD_WIDTH:
		if board[2][j] == -6:
			return true
		if board[13][j] == 6:
			return true
	return false
func is_resignation_victory():
	return false
func movement(movement_pattern, building_capture, piece_position, companion, movement_range, infiltrator : bool):
	var _moves = []
	if !battlefield(piece_position): return _moves
	var directions = []
	var knight = [Vector2(2, 1), Vector2(2, -1), Vector2(1, 2), Vector2(1, -2),	
				Vector2(-2, 1), Vector2(-2, -1), Vector2(-1, 2), Vector2(-1, -2)]
	var straight = [Vector2(0, 1), Vector2(0, -1), Vector2(1, 0), Vector2(-1, 0)]
	var diagonal = [Vector2(1, 1), Vector2(-1, -1), Vector2(1, -1), Vector2(-1, 1)]
	if movement_pattern.contains("knight"):
		for r in knight:
			directions.append(r)
	if movement_pattern.contains("straight"):
		for r in straight:
			directions.append(r)
	if movement_pattern.contains("diagonal"):
		for r in diagonal:
			directions.append(r)
	for i in directions:
		var pos = piece_position
		var stop_now = movement_range
		pos += i
		while battlefield(pos) && stop_now != 0:
			if companion != 0 && is_empty(piece_position+i+i) && is_board(piece_position+i,companion) && battlefield(piece_position+i+i):
				_moves.append(piece_position+i)
			if is_empty(pos): _moves.append(pos)
			elif ((is_enemy_incl(pos) && building_capture) || is_enemy(pos)) && enemy_ranks(piece_position):
				_moves.append(pos)
				break
			elif ((is_enemy_incl(pos) && building_capture) || is_enemy(pos)) && !infiltrator:
				_moves.append(pos)
				break
			elif !(get_board(pos) == companion * move_from_team) || companion == 0: 
				exception_handler(pos, _moves, piece_position)
				break
			pos += i
			stop_now += -1
	moves_cull(_moves)
	return _moves
func enemy_ranks(pos):
	if (pos.x <= 5 && !blue) || (pos.x >= 10 && blue):
		return true
	return false
func home_ranks(pos):
	if (pos.x <= 5 && blue) || (pos.x >= 10 && !blue):
		return true
	return false
func is_board(get_pos, piece_id):
	var output = board[get_pos.x][get_pos.y]
	if output * move_from_team == piece_id:
		return true
	return false
func _on_check_button_button_up() -> void:
	if administrator:
		TURN_MARKER = preload("res://dunji_assets/timer.png")
		administrator = false
	else:
		TURN_MARKER = preload("res://dunji_assets/timer_admin.png")
		administrator = true
	delete_dots()
	state = false
func _on_rotation_button_button_up() -> void:
	var o = 2 if round($"../Camera2D".rotation_degrees) == 180 else -2
	$PieceBox2/Shadow4.position += Vector2(o,o)
	$PieceBox/Shadow3.position += Vector2(o,o)
	$DunjiBoardBottomLeft/BoardBLShad.position += Vector2(o,o)
	$DunjiBoardBottomRight/BoardBRShad.position += Vector2(o,o)
	$DunjiBoardTopRight/BoardTRShad.position += Vector2(o,o)
	$DunjiBoardTopRight/BoardTRShad.position += Vector2(o,o)
	$"../Camera2D".rotation_degrees = round(abs($"../Camera2D".rotation_degrees-180))
	GlobalOrientation.blue_perspective = !GlobalOrientation.blue_perspective
	config.set_value("settings", "rotation", GlobalOrientation.blue_perspective)
	config.save("res://config.cfg")
func _on_quit_button_up() -> void:
	config.set_value("settings", "last_save", loaded_save)
	config.save("res://config.cfg")
	var board_main = $"."
	var board_acc = $"../Camera2D/Control"
	var tween = create_tween()
	tween.tween_property(board_main, "position", Vector2(board_main.position.x,board_main.position.y-800), 1.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.parallel()
	tween.tween_property(board_acc, "position", Vector2(board_acc.position.x,board_acc.position.y-800), 1.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func _on_move_timer_timeout() -> void:
	do_random_move()
