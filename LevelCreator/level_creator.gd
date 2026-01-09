class_name LevelCreator extends Node2D

# Textures
const BREAKABLE_WALL_TEXTURE = preload("uid://dns6cpd7qmkgo")
const CIRCLE_TEXTURE = preload("uid://bnr78mdy5q88q")
const DOOR_TEXTURE = preload("uid://cdr7si65lvetu")
const MOON_TEXTURE = preload("uid://b5gmo1jq57k3e")
const SQUARE_TEXTURE = preload("uid://d20v63bj4fk6i")
const TRIANGLE_TEXTURE = preload("uid://c1mbkkisfferb")
const GOAL_TEXTURE = preload("res://LevelCreator/Sprites/goal.png")
const GOAL_ICON_TEXTURE = preload("uid://bc8l4cq05a18u")
const GOAL_ICON_X_TEXTURE = preload("uid://uto07xo0qv3g")

# Spawns
const CIRCLE_SPAWN = preload("uid://cp3kqrfqht8v6")
const MOON_SPAWN = preload("uid://b5roxb43svd8k")
const SQUARE_SPAWN = preload("uid://w6cdn4briwmh")
const TRIANGLE_SPAWN = preload("uid://rbc1geulex1e")

# Objects
const BREAKABLE_WALL = preload("uid://dqm8v3qt8ah42")
const BUTTON_DOOR = preload("uid://c6j301y8f566b")
const BUTTON = preload("uid://b26njhvwluy2i")
const GOAL = preload("uid://bnwirpv537d3o")

enum TileTransform {
	ROTATE_0 = 0,
	ROTATE_90 = TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_H,
	ROTATE_180 = TileSetAtlasSource.TRANSFORM_FLIP_H | TileSetAtlasSource.TRANSFORM_FLIP_V,
	ROTATE_270 = TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_V,
}

signal returning_to_start
signal save_the_level

@onready var tilemap: TileMapLayer = $Tilemap

@onready var movable_sprite: Sprite2D = $MovableSprite

@onready var menu_mover: Node2D = $Control/MenuMover
@onready var panel_container: PanelContainer = $Control/MenuMover/PanelContainer

@onready var return_to_start_popup: PanelContainer = $Control/ReturnToStartPopup
@onready var button_return_to_start_popup_yes: Button = $Control/ReturnToStartPopup/VBoxContainer/ButtonYes
@onready var button_return_to_start_popup_no: Button = $Control/ReturnToStartPopup/VBoxContainer/ButtonNo

@onready var no_save_popup: PanelContainer = $Control/NoSavePopup
@onready var button_ok: Button = $Control/NoSavePopup/MarginContainer/VBoxContainer/ButtonOK

@onready var button_drag: Button = $Control/MenuMover/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/ButtonDrag
@onready var button_x: Button = $Control/MenuMover/PanelContainer/VBoxContainer/HBoxContainer/ButtonX

@onready var tile_0: Button = $Control/MenuMover/PanelContainer/VBoxContainer/HBoxContainer2/Tile0
@onready var tile_1: Button = $Control/MenuMover/PanelContainer/VBoxContainer/HBoxContainer2/Tile1
@onready var tile_2: Button = $Control/MenuMover/PanelContainer/VBoxContainer/HBoxContainer2/Tile2
@onready var tile_3: Button = $Control/MenuMover/PanelContainer/VBoxContainer/HBoxContainer2/Tile3
@onready var tile_4: Button = $Control/MenuMover/PanelContainer/VBoxContainer/HBoxContainer2/Tile4
@onready var tile_5: Button = $Control/MenuMover/PanelContainer/VBoxContainer/HBoxContainer2/Tile5
@onready var tile_6: Button = $Control/MenuMover/PanelContainer/VBoxContainer/HBoxContainer2/Tile6
@onready var tile_7: Button = $Control/MenuMover/PanelContainer/VBoxContainer/HBoxContainer2/Tile7
@onready var tile_8: Button = $Control/MenuMover/PanelContainer/VBoxContainer/HBoxContainer2/Tile8
@onready var tile_9: Button = $Control/MenuMover/PanelContainer/VBoxContainer/HBoxContainer2/Tile9
@onready var tile_10: Button = $Control/MenuMover/PanelContainer/VBoxContainer/HBoxContainer3/Tile10
@onready var tile_11: Button = $Control/MenuMover/PanelContainer/VBoxContainer/HBoxContainer3/Tile11
@onready var tile_12: Button = $Control/MenuMover/PanelContainer/VBoxContainer/HBoxContainer3/Tile12
@onready var tile_13: Button = $Control/MenuMover/PanelContainer/VBoxContainer/HBoxContainer3/Tile13
@onready var tile_14: Button = $Control/MenuMover/PanelContainer/VBoxContainer/HBoxContainer3/Tile14
@onready var tile_15: Button = $Control/MenuMover/PanelContainer/VBoxContainer/HBoxContainer3/Tile15
@onready var tile_16: Button = $Control/MenuMover/PanelContainer/VBoxContainer/HBoxContainer3/Tile16
@onready var tile_17: Button = $Control/MenuMover/PanelContainer/VBoxContainer/HBoxContainer3/Tile17
@onready var tile_18: Button = $Control/MenuMover/PanelContainer/VBoxContainer/HBoxContainer3/Tile18
@onready var tile_empty: Button = $Control/MenuMover/PanelContainer/VBoxContainer/HBoxContainer3/TileEMPTY

@onready var square_spawn: Button = $Control/MenuMover/PanelContainer/VBoxContainer/HBoxContainer4/SquareSpawn
@onready var triangle_spawn: Button = $Control/MenuMover/PanelContainer/VBoxContainer/HBoxContainer4/TriangleSpawn
@onready var circle_spawn: Button = $Control/MenuMover/PanelContainer/VBoxContainer/HBoxContainer4/CircleSpawn
@onready var moon_spawn: Button = $Control/MenuMover/PanelContainer/VBoxContainer/HBoxContainer4/MoonSpawn

@onready var breakable_door: Button = $Control/MenuMover/PanelContainer/VBoxContainer/HBoxContainer4/BreakableDoor
@onready var button_door: Button = $Control/MenuMover/PanelContainer/VBoxContainer/HBoxContainer4/ButtonDoor
@onready var button: Button = $Control/MenuMover/PanelContainer/VBoxContainer/HBoxContainer4/Button
@onready var goal: Button = $Control/MenuMover/PanelContainer/VBoxContainer/HBoxContainer4/Goal

@onready var test_level: Button = $Control/MenuMover/PanelContainer/VBoxContainer/HBoxContainer5/TestLevel
@onready var save_level: Button = $Control/MenuMover/PanelContainer/VBoxContainer/HBoxContainer5/SaveLevel

@onready var filepath_full_popup: PanelContainer = $Control/FilepathFullPopup
@onready var button_ok_2: Button = $Control/FilepathFullPopup/MarginContainer/VBoxContainer/ButtonOK

@onready var save_confirmation_popup: PanelContainer = $Control/SaveConfirmationPopup
@onready var button_save_confirmation_yes: Button = $Control/SaveConfirmationPopup/MarginContainer/VBoxContainer/ButtonYes
@onready var button_save_confirmation_no: Button = $Control/SaveConfirmationPopup/MarginContainer/VBoxContainer/ButtonNo

var drag_active : bool = false
var sprite_step : Vector2 = Vector2(16, 16)
var sprite_offset : Vector2 = Vector2(-8, -8)
var object_offset : Vector2
var source_id : int = 1
var atlas_coords : Vector2 = Vector2.ZERO
var alternative_tile : int = 0
var painting : bool = false
var last_painted : Vector2i = Vector2i.ZERO
var drawing_tiles : bool = true
var mouse_over_object : bool = false
var popup_active : bool = false
var dragging_object : Node2D = null
var clicked_pos : Vector2
var object_menu_active : bool = false
var door_offset : Vector2 = Vector2(-8, -24)
var button_offset : Vector2 = Vector2(0, 0)
var drawing_line : Node2D
var line_size : int = 2
var line_color : Color = Color(0.0, 0.906, 1.0, 1.0)
var goal_offset : Vector2 = Vector2(0, 0)
var save_my_level : bool = false

func _ready() -> void:
	_button_connections()
	popup_active = false
	movable_sprite.texture = tile_1.icon
	PlayerManager.player = null
	PlayerManager.players.clear()
	for c in PlayerManager.get_children():
		if c:
			c.queue_free()


func _process(_delta: float) -> void:
	if drag_active:
		menu_mover.global_position = get_local_mouse_position()
	
	check_sprite_visibility()
	sprite_pos()
	
	_drag_check()
	
	if painting and movable_sprite.visible and drawing_tiles:
		paint()
	
	drag_objects()
	
	queue_redraw()

# ~~~~~~~~~~ BUTTONS ~~~~~~~~~~~
func _on_drag_pressed() -> void:
	drawing_tiles = false
	drag_active = true
	_hide_object_menu()
	check_if_goal_used()

func _on_drag_released() -> void:
	for b in get_tree().get_nodes_in_group("level_creator_menu_tile"):
		if b.icon == movable_sprite.texture:
			drawing_tiles = true
	drag_active = false

func _on_x_pressed() -> void:
	return_to_start_popup.visible = true
	popup_active = true
	_hide_object_menu()
	check_if_goal_used()

func _on_tile_pressed(btn : Button) -> void:
	drawing_tiles = true
	sprite_step = Vector2(16, 16)
	movable_sprite.texture = btn.icon
	set_atlas_coords(btn)
	_hide_object_menu()
	check_if_goal_used()

func _on_spawn_pressed(btn : Button) -> void:
	drawing_tiles = false
	sprite_step = Vector2(8, 8)
	set_spawn_icon(btn)
	_hide_object_menu()
	check_if_goal_used()

func _on_breakable_door_pressed() -> void:
	drawing_tiles = false
	sprite_step = Vector2(16, 16)
	movable_sprite.texture = BREAKABLE_WALL_TEXTURE
	_hide_object_menu()
	check_if_goal_used()

func _on_button_door_pressed() -> void:
	drawing_tiles = false
	sprite_step = Vector2(16, 16)
	movable_sprite.texture = DOOR_TEXTURE
	_hide_object_menu()
	check_if_goal_used()

func _on_button_pressed() -> void:
	drawing_tiles = false
	sprite_step = Vector2(8, 8)
	movable_sprite.texture = button.icon
	_hide_object_menu()
	check_if_goal_used()

func _on_goal_pressed() -> void:
	check_if_goal_used()
	if goal.icon == GOAL_ICON_X_TEXTURE:
		for n in get_tree().get_nodes_in_group("level_creator_objects"):
			if n is Goal:
				n.queue_free()
				goal.icon = GOAL_ICON_TEXTURE
		return
	drawing_tiles = false
	sprite_step = Vector2(8, 8)
	movable_sprite.texture = GOAL_TEXTURE
	goal.icon = GOAL_ICON_X_TEXTURE
	_hide_object_menu()

func _on_test_pressed() -> void:
	var g : bool = false
	var c : bool = false
	for n in get_tree().get_nodes_in_group("level_creator_objects"):
		if n is Goal:
			g = true
		if n is PlayerSpawn:
			c = true
	
	if g and c:
		StartMenu.test_mode = true
		var data := _serialize_level()
		LevelManager.load_custom_level_from_data(data)
	else:
		popup_active = true
		no_save_popup.visible = true

func _on_save_pressed() -> void:
	var g : bool = false
	var c : bool = false
	for n in get_tree().get_nodes_in_group("level_creator_objects"):
		if n is Goal:
			g = true
		if n is PlayerSpawn:
			c = true
	
	if g and c:
		var data := _serialize_level()
		var json := JSON.stringify(data, "\t")
		
		var dir_path := "user://levels"
		DirAccess.make_dir_recursive_absolute(dir_path)
		
		var file_path = dir_path
		
		var full : bool = true
		for i in range(9):
			if not FileAccess.file_exists(file_path + "/C" + str(i + 1) + ".json"):
				file_path += "/C" + str(i + 1) + ".json"
				full = false
				save_confirmation_popup.visible = true
				popup_active = true
				await save_the_level
				if not save_my_level:
					return
				break
		if full:
			filepath_full_popup.visible = true
			popup_active = true
			return
		
		var file := FileAccess.open(file_path, FileAccess.WRITE)
		if file:
			file.store_string(json)
			file.close()
			print("Saved level to: ", file_path)
			PauseMenu.return_to_start()
			PauseMenu.update_buttons()
		else:
			file.close()
			push_error("Failed to open file for saving level: " + file_path) # put another popup here
	else:
		popup_active = true
		no_save_popup.visible = true

# ~~~~~~~~~~~ POP-UPS ~~~~~~~~~~~~~~~~~
func _on_return_to_start_popup_yes() -> void:
	returning_to_start.emit()
	PauseMenu.return_to_start()

func _on_return_to_start_popup_no() -> void:
	return_to_start_popup.visible = false
	no_save_popup.visible = false
	filepath_full_popup.visible = false
	save_confirmation_popup.visible = false
	save_my_level = false
	save_the_level.emit()
	popup_active = false

func _on_save_confirmation_popup_yes() -> void:
	save_my_level = true
	save_the_level.emit()

# ~~~~~~~~~~~~ INPUTS ~~~~~~~~~~~~~~~~~~
func _input(event: InputEvent) -> void:
	if popup_active:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and movable_sprite.visible:
		if event.is_pressed():
			clicked_pos = get_local_mouse_position()
			if movable_sprite.texture == SQUARE_TEXTURE:
				place_spawn("Square")
			elif movable_sprite.texture == TRIANGLE_TEXTURE:
				place_spawn("Triangle")
			elif movable_sprite.texture == CIRCLE_TEXTURE:
				place_spawn("Circle")
			elif movable_sprite.texture == MOON_TEXTURE:
				place_spawn("Moon")
			elif movable_sprite.texture == BREAKABLE_WALL_TEXTURE:
				place_breakable_wall()
			elif movable_sprite.texture == DOOR_TEXTURE:
				place_door()
			elif movable_sprite.texture == button.icon:
				place_button()
			elif movable_sprite.texture == GOAL_TEXTURE:
				place_goal()
			else:
				painting = true
		else:
			painting = false
			if dragging_object:
				dragging_object = null
				object_offset = Vector2()
	
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and !movable_sprite.visible:
		if event.is_pressed():
			clicked_pos = get_local_mouse_position()
			for n in get_tree().get_nodes_in_group("level_creator_objects"):
				if n.mouse_captured:
					if n is not MyButton and n is not ButtonDoor:
						drawing_line = null
					if drawing_line and drawing_line is ButtonDoor:
						if n is MyButton:
							connect_door_to_button(drawing_line, n)
							return
					elif drawing_line and drawing_line is MyButton:
						if n is ButtonDoor:
							connect_door_to_button(n, drawing_line)
							return
					dragging_object = n
					break
			if drawing_line:
				drawing_line = null
		else:
			if clicked_pos.distance_to(get_local_mouse_position()) <= 2:
				for n in get_tree().get_nodes_in_group("level_creator_objects"):
					if n.mouse_captured:
						movable_sprite.texture = null
						_show_object_menu(n)
			if dragging_object:
				dragging_object = null
				object_offset = Vector2()
	
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and movable_sprite.visible:
		if event.is_pressed():
			source_id = 0
			painting = true
		else:
			source_id = 1
			painting = false
	
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and !movable_sprite.visible:
		if event.is_pressed():
			for n in get_tree().get_nodes_in_group("level_creator_objects"):
				if n.mouse_captured:
					if n is MyButton:
						_on_button_door_connector_pressed(n)
					elif n is ButtonDoor:
						_on_door_button_connector_pressed(n)
					n.queue_free()
					mouse_over_object = false
					if n is Goal:
						goal.icon = GOAL_ICON_TEXTURE
		else:
			pass
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("rotate_tile_left"):
		alternative_tile = alternative_tile | TileTransform.ROTATE_270
		movable_sprite.rotate(deg_to_rad(270))
	elif event.is_action_pressed("rotate_tile_right"):
		alternative_tile = alternative_tile | TileTransform.ROTATE_90
		movable_sprite.rotate(deg_to_rad(90))
	elif event.is_action_pressed("flip_tile_h"):
		alternative_tile = alternative_tile | TileSetAtlasSource.TRANSFORM_FLIP_H
		movable_sprite.scale.x = movable_sprite.scale.x * -1
	elif event.is_action_pressed("flip_tile_v"):
		alternative_tile = alternative_tile | TileSetAtlasSource.TRANSFORM_FLIP_V
		movable_sprite.scale.y = movable_sprite.scale.y * -1
	

# ~~~~~~~~~~~~ PERSONAL FUNCTIONS ~~~~~~~~~~~~~
func check_sprite_visibility() -> void:
	for n in get_tree().get_nodes_in_group("level_creator_objects"):
		if n is BreakableWall or n is ButtonDoor or n is MyButton:
			if n.panel_container_vertical.visible or n.panel_container_horizontal.visible:
				movable_sprite.visible = false
				return
			if n is Goal:
				movable_sprite.visible = false
				return
	var menu_rect := Rect2(
		panel_container.global_position.x, 
		panel_container.global_position.y, 
		panel_container.size.x, 
		panel_container.size.y
		)
	if (
		menu_rect.has_point(get_local_mouse_position())
		or mouse_over_object
		or popup_active
		or object_menu_active
		or dragging_object
		):
		movable_sprite.visible = false
	else:
		movable_sprite.visible = true

func sprite_pos() -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	var cell : Vector2 = (mouse_pos / sprite_step).floor()
	if movable_sprite.visible:
		movable_sprite.global_position = (cell + Vector2(0.5, 0.5)) * sprite_step
		if movable_sprite.texture == button.icon:
			movable_sprite.global_position += Vector2(-4, 0)
		elif movable_sprite.texture == GOAL_TEXTURE:
			movable_sprite.global_position += Vector2(4, 4)
		elif (
			movable_sprite.texture == SQUARE_TEXTURE
			or movable_sprite.texture == CIRCLE_TEXTURE
			or movable_sprite.texture == TRIANGLE_TEXTURE
			or movable_sprite.texture == MOON_TEXTURE
			):
				movable_sprite.global_position += Vector2(-4, 4)

func paint() -> void:
	var coords := tilemap.local_to_map(movable_sprite.global_position)
	if coords == last_painted:
		return
	last_painted = coords
	
	var min_x := 0
	var min_y := 0
	var max_x := 71
	var max_y := 40
	if coords.x == min_x or coords.x == max_x or coords.y == min_y or coords.y == max_y:
		return
	
	tilemap.set_cell(coords, source_id, atlas_coords, alternative_tile)
	print("Set Tilemap:")
	print("Coords: " + str(coords))
	print("Atlas Coords: " + str(atlas_coords))
	print("Alternative Tile: " + str(alternative_tile))
	print("\n")

func _on_mouse_entered() -> void:
	mouse_over_object = true

func _on_mouse_exited() -> void:
	for n in get_tree().get_nodes_in_group("level_creator_objects"):
		if n.mouse_captured:
			return
	mouse_over_object = false

func _drag_check() -> void:
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		return
	if dragging_object:
		return
	var check_obj : bool = false
	for n in get_tree().get_nodes_in_group("level_creator_objects"):
		if n.mouse_captured:
			check_obj = true
			break
	if !movable_sprite.visible and clicked_pos.distance_to(get_local_mouse_position()) > 3 and check_obj:
		for n in get_tree().get_nodes_in_group("level_creator_objects"):
			if n.mouse_captured:
				dragging_object = n
				break

func drag_objects() -> void:
	if dragging_object != null:
		if clicked_pos.distance_to(get_local_mouse_position()) <= 3:
			return
		if not object_offset:
			object_offset = dragging_object.global_position - get_local_mouse_position()
		dragging_object.global_position = get_local_mouse_position() + object_offset
		dragging_object._snap_to_grid()

func place_spawn(type : String) -> void:
	var s : PlayerSpawn
	
	match type:
		"Square":
			s = SQUARE_SPAWN.instantiate()
		"Triangle":
			s = TRIANGLE_SPAWN.instantiate()
		"Circle":
			s = CIRCLE_SPAWN.instantiate()
		"Moon":
			s = MOON_SPAWN.instantiate()
	
	s.global_position = movable_sprite.global_position + (Vector2.DOWN * 8)
	add_child(s)
	s.mouse_area.mouse_entered.connect(_on_mouse_entered)
	s.mouse_area.mouse_exited.connect(_on_mouse_exited)
	s._snap_to_grid()

func _show_object_menu(n : Node2D) -> void:
	_hide_object_menu()
	object_menu_active = true
	if n is MyButton:
		n.panel_container_vertical.visible = true
	elif n is BreakableWall or n is ButtonDoor:
		if n.side == n.SIDE.VERTICAL:
			n.panel_container_vertical.visible = true
		else:
			n.panel_container_horizontal.visible = true

func _hide_object_menu() -> void:
	object_menu_active = false
	for n in get_tree().get_nodes_in_group("level_creator_objects"):
		if n is BreakableWall or n is ButtonDoor or n is MyButton:
			n.panel_container_vertical.visible = false
			n.panel_container_horizontal.visible = false

func place_breakable_wall() -> void:
	var b : BreakableWall = BREAKABLE_WALL.instantiate()
	b.global_position = movable_sprite.global_position
	add_child(b)
	b.mouse_area.mouse_entered.connect(_on_mouse_entered)
	b.mouse_area.mouse_exited.connect(_on_mouse_exited)
	b._snap_to_grid()

func place_door() -> void:
	var d : ButtonDoor = BUTTON_DOOR.instantiate()
	d.global_position = movable_sprite.global_position + door_offset
	add_child(d)
	d.mouse_area.mouse_entered.connect(_on_mouse_entered)
	d.mouse_area.mouse_exited.connect(_on_mouse_exited)
	d.door_button_connector_pressed.connect(_on_door_button_connector_pressed.bind(d))
	d._snap_to_grid()

func place_button() -> void:
	var b : MyButton = BUTTON.instantiate()
	b.global_position = movable_sprite.global_position + button_offset
	add_child(b)
	b.mouse_area.mouse_entered.connect(_on_mouse_entered)
	b.mouse_area.mouse_exited.connect(_on_mouse_exited)
	b.button_door_connector_pressed.connect(_on_button_door_connector_pressed.bind(b))
	b._snap_to_grid()

func place_goal() -> void:
	var g : Goal = GOAL.instantiate()
	g.global_position = movable_sprite.global_position + goal_offset
	add_child(g)
	g.mouse_area.mouse_entered.connect(_on_mouse_entered)
	g.mouse_area.mouse_exited.connect(_on_mouse_exited)
	g._snap_to_grid()
	movable_sprite.texture = null

func _on_door_button_connector_pressed(d : ButtonDoor) -> void:
	if d.button:
		d.button.button_door_connector.icon = d.button.DOOR_NOT_CONNECTED
		d.button.button_door_connector_2.icon = d.button.DOOR_NOT_CONNECTED
		d.button_button.icon = d.BUTTON_X
		d.button_button_2.icon = d.BUTTON_X
		d.button_visualizer.texture = d.BUTTON_X
		d.button = null
	else:
		drawing_line = d

func _on_button_door_connector_pressed(b : MyButton) -> void:
	for n in get_tree().get_nodes_in_group("level_creator_objects"):
		if n is ButtonDoor:
			if n.button == b:
				n.button = null
				n.button_button.icon = n.BUTTON_X
				n.button_button_2.icon = n.BUTTON_X
				n.button_visualizer.texture = n.BUTTON_X
				b.button_door_connector.icon = b.DOOR_NOT_CONNECTED
				b.button_door_connector_2.icon = b.DOOR_NOT_CONNECTED
				return
	drawing_line = b

func connect_door_to_button(d : ButtonDoor, b : MyButton) -> void:
	if d.button:
		for n in get_tree().get_nodes_in_group("level_creator_objects"):
			if n == d.button:
				n.button_door_connector.icon = n.DOOR_NOT_CONNECTED
				n.button_door_connector_2.icon = n.DOOR_NOT_CONNECTED
	
	d.button = b
	drawing_line = null
	d.button_button.icon = d.BUTTON_O
	d.button_button_2.icon = d.BUTTON_O
	b.button_door_connector.icon = b.DOOR_CONNECTED
	b.button_door_connector_2.icon = b.DOOR_CONNECTED
	d.button_visualizer.texture = d.BUTTON_O

func _draw() -> void:
	# DOOR TO MOUSE
	if drawing_line:
		var n = drawing_line
		if n is ButtonDoor:
			var from : Vector2 = to_local(n.collision_shape.global_position)
			var to : Vector2 = get_local_mouse_position()
			draw_line(from, to, line_color, line_size)
	
	# BUTTON TO MOUSE
	if drawing_line:
		var n = drawing_line
		if n is MyButton:
			var from : Vector2 = to_local(n.mouse_area.global_position)
			var to : Vector2 = get_local_mouse_position()
			draw_line(from, to, line_color, line_size)
	
	# DOOR TO BUTTON
	for n in get_tree().get_nodes_in_group("level_creator_objects"):
		if n is ButtonDoor:
			if n.button:
				var from : Vector2 = to_local(n.collision_shape.global_position)
				var to : Vector2 = to_local(n.button.mouse_area.global_position)
				draw_line(from, to, n.line_color, line_size)

func check_if_goal_used() -> void:
	for n in get_tree().get_nodes_in_group("level_creator_objects"):
		if n is Goal:
			goal.icon = GOAL_ICON_X_TEXTURE
			return
	goal.icon = GOAL_ICON_TEXTURE

func set_spawn_icon(btn : Button) -> void:
	match btn.name:
		"SquareSpawn":
			movable_sprite.texture = SQUARE_TEXTURE
		"TriangleSpawn":
			movable_sprite.texture = TRIANGLE_TEXTURE
		"CircleSpawn":
			movable_sprite.texture = CIRCLE_TEXTURE
		"MoonSpawn":
			movable_sprite.texture = MOON_TEXTURE
		_:
			movable_sprite.texture = btn.icon

func _serialize_tilemap() -> Array:
	var result: Array = []
	for coords in tilemap.get_used_cells():
		source_id = 1
		atlas_coords = tilemap.get_cell_atlas_coords(coords)
		var alt := tilemap.get_cell_alternative_tile(coords)
		result.append({
			"x": coords.x,
			"y": coords.y,
			"source_id": source_id,
			"atlas_x": atlas_coords.x,
			"atlas_y": atlas_coords.y,
			"alt": alt,
		})
	return result

func _serialize_objects() -> Array:
	var result: Array = []
	for n in get_tree().get_nodes_in_group("level_creator_objects"):
		var obj_type := ""
		if n is BreakableWall:
			obj_type = "BreakableWall"
			result.append({
				"type": obj_type,
				"x": n.global_position.x,
				"y": n.global_position.y,
				"size": n.size,
				"side": n.side
			})
		elif n is ButtonDoor:
			obj_type = "ButtonDoor"
			var door_dict := {
				"type": obj_type,
				"x": n.global_position.x,
				"y": n.global_position.y,
				"size": n.size,
				"side": n.side,
				"opening_dir": n.opening_dir,
				"origin": n.origin
			}
			if n.button:
				door_dict["button_x"] = n.button.global_position.x
				door_dict["button_y"] = n.button.global_position.y
			result.append(door_dict)
		elif n is MyButton:
			obj_type = "MyButton"
			result.append({
				"type": obj_type,
				"x": n.global_position.x,
				"y": n.global_position.y,
				"side": n.side
			})
		elif n is PlayerSpawn:
			obj_type = "PlayerSpawn"
			match n.type:
				n.TYPE.SQUARE:
					result.append({
						"type": obj_type,
						"x": n.global_position.x,
						"y": n.global_position.y,
						"_type": "Square"
					})
				n.TYPE.TRIANGLE:
					result.append({
						"type": obj_type,
						"x": n.global_position.x,
						"y": n.global_position.y,
						"_type": "Triangle"
					})
				n.TYPE.CIRCLE:
					result.append({
						"type": obj_type,
						"x": n.global_position.x,
						"y": n.global_position.y,
						"_type": "Circle"
					})
				n.TYPE.MOON:
					result.append({
						"type": obj_type,
						"x": n.global_position.x,
						"y": n.global_position.y,
						"_type": "Moon"
					})
		elif n is Goal:
			obj_type = "Goal"
			result.append({
				"type": obj_type,
				"x": n.global_position.x,
				"y": n.global_position.y
			})
		else:
			continue
	
	return result

func _serialize_level() -> Dictionary:
	return {
		"tiles": _serialize_tilemap(),
		"objects": _serialize_objects(),
	}

func _button_connections() -> void:
	if not button_drag.button_down.is_connected(_on_drag_pressed):
		button_drag.button_down.connect(_on_drag_pressed)
	if not button_drag.button_up.is_connected(_on_drag_released):
		button_drag.button_up.connect(_on_drag_released)
	if not button_x.pressed.is_connected(_on_x_pressed):
		button_x.pressed.connect(_on_x_pressed)
	if not button_return_to_start_popup_yes.pressed.is_connected(_on_return_to_start_popup_yes):
		button_return_to_start_popup_yes.pressed.connect(_on_return_to_start_popup_yes)
	if not button_return_to_start_popup_no.pressed.is_connected(_on_return_to_start_popup_no):
		button_return_to_start_popup_no.pressed.connect(_on_return_to_start_popup_no)
	for btn in get_tree().get_nodes_in_group("level_creator_menu_tile"):
		if not btn.pressed.is_connected(_on_tile_pressed.bind(btn)):
			btn.pressed.connect(_on_tile_pressed.bind(btn))
	for btn in get_tree().get_nodes_in_group("level_creator_menu_spawn"):
		if not btn.pressed.is_connected(_on_spawn_pressed.bind(btn)):
			btn.pressed.connect(_on_spawn_pressed.bind(btn))
	if not breakable_door.pressed.is_connected(_on_breakable_door_pressed):
		breakable_door.pressed.connect(_on_breakable_door_pressed)
	if not button_door.pressed.is_connected(_on_button_door_pressed):
		button_door.pressed.connect(_on_button_door_pressed)
	if not button.pressed.is_connected(_on_button_pressed):
		button.pressed.connect(_on_button_pressed)
	if not goal.pressed.is_connected(_on_goal_pressed):
		goal.pressed.connect(_on_goal_pressed)
	if not test_level.pressed.is_connected(_on_test_pressed):
		test_level.pressed.connect(_on_test_pressed)
	if not save_level.pressed.is_connected(_on_save_pressed):
		save_level.pressed.connect(_on_save_pressed)
	if not button_ok.pressed.is_connected(_on_return_to_start_popup_no):
		button_ok.pressed.connect(_on_return_to_start_popup_no)
	if not button_ok_2.pressed.is_connected(_on_return_to_start_popup_no):
		button_ok_2.pressed.connect(_on_return_to_start_popup_no)
	if not button_save_confirmation_yes.pressed.is_connected(_on_save_confirmation_popup_yes):
		button_save_confirmation_yes.pressed.connect(_on_save_confirmation_popup_yes)
	if not button_save_confirmation_no.pressed.is_connected(_on_return_to_start_popup_no):
		button_save_confirmation_no.pressed.connect(_on_return_to_start_popup_no)

func set_atlas_coords(btn : Button) -> void:
	match btn.name:
		"Tile0":
			atlas_coords = Vector2(9, 0)
		"Tile1":
			atlas_coords = Vector2(0, 0)
		"Tile2":
			atlas_coords = Vector2(1, 0)
		"Tile3":
			atlas_coords = Vector2(2, 0)
		"Tile4":
			atlas_coords = Vector2(3, 0)
		"Tile5":
			atlas_coords = Vector2(4, 0)
		"Tile6":
			atlas_coords = Vector2(5, 0)
		"Tile7":
			atlas_coords = Vector2(6, 0)
		"Tile8":
			atlas_coords = Vector2(7, 0)
		"Tile9":
			atlas_coords = Vector2(8, 0)
		"Tile10":
			atlas_coords = Vector2(0, 1)
		"Tile11":
			atlas_coords = Vector2(1, 1)
		"Tile12":
			atlas_coords = Vector2(2, 1)
		"Tile13":
			atlas_coords = Vector2(3, 1)
		"Tile14":
			atlas_coords = Vector2(4, 1)
		"Tile15":
			atlas_coords = Vector2(5, 1)
		"Tile16":
			atlas_coords = Vector2(6, 1)
		"Tile17":
			atlas_coords = Vector2(7, 1)
		"Tile18":
			atlas_coords = Vector2(8, 1)
