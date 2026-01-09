extends Node

signal level_load_started
signal level_loaded
signal data_loaded

var current_level := 1
var level : Level
var level_started : bool = false
var custom_level_data: Dictionary = {}
var custom_level_mode: bool = false
var max_levels : int = 10
var custom_level_file_path : String

func _ready() -> void:
	custom_level_file_path = ""

func load_next_level() -> void:
	custom_level_file_path = ""
	custom_level_mode = false
	current_level = current_level + 1
	
	PlayerManager.players_spawned = false
	level_started = false
	
	get_tree().paused = true
	
	await SceneTransition.fade_out()
	
	if StartMenu.visible and not StartMenu.level_creator_active:
		StartMenu.levels_background.visible = false
		StartMenu.visible = false
		StartMenu.game_started = true
	
	var level_name := "res://Levels/L" + str(current_level) + ".tscn"
	
	level_load_started.emit()
	
	await get_tree().process_frame
	
	if current_level > max_levels:
		current_level = 1
		PauseMenu.return_to_start()
		return
	
	get_tree().change_scene_to_file(level_name)
	
	var unlocked : bool = false
	for i in SaveManager.unlocked_levels:
		if i == current_level:
			unlocked = true
	if not unlocked:
		SaveManager.unlocked_levels.append(current_level)
		SaveManager.save_game()
		PauseMenu.update_buttons()
	
	await get_tree().process_frame
	
	level = get_node("/root/L" + str(current_level))
	
	level_loaded.emit()
	
	await SceneTransition.fade_in()
	
	for p in PlayerManager.players:
		if p.type == "Moon":
			if p.gravity_scale == 1:
				p._create_moon()
	
	get_tree().paused = false

func load_new_level(_level : int) -> void:
	current_level = _level - 1
	load_next_level()

func load_custom_level(file_path : String) -> void:
	if not FileAccess.file_exists(file_path):
		push_error("Custom level file does not exist: " + file_path)
		return
	
	custom_level_file_path = file_path
	var json_text := FileAccess.get_file_as_string(file_path)
	var data : Dictionary = JSON.parse_string(json_text)
	load_custom_level_from_data(data)

func return_to_level_creator() -> void:
	StartMenu.game_started = false
	StartMenu.test_mode = false
	custom_level_mode = false
	
	PlayerManager.players_spawned = false
	level_started = false
	get_tree().paused = true
	
	await SceneTransition.fade_out()
	
	get_child(0).visible = true
	get_child(0).tilemap.collision_enabled = true
	get_tree().root.get_node("/root/CustomLevel").free()
	get_child(0).reparent(get_tree().root)
	
	StartMenu.level_creator_active = true
	
	await get_tree().process_frame
	
	PlayerManager.players.clear()
	PlayerManager.player = null
	
	for c in PlayerManager.get_children():
		c.queue_free()
	
	await SceneTransition.fade_in()
	get_tree().paused = false

func load_custom_level_from_data(data: Dictionary) -> void:
	custom_level_mode = true
	
	PlayerManager.players_spawned = false
	level_started = false
	get_tree().paused = true
	
	await SceneTransition.fade_out()
	
	if StartMenu.test_mode:
		var simultaneous_scene = preload("res://Levels/CustomLevel.tscn").instantiate()
		get_tree().root.add_child(simultaneous_scene)
		for n in get_tree().get_nodes_in_group("level_creator"):
			n.reparent(LevelManager)
			n.visible = false
			n.tilemap.collision_enabled = false
			break
	else:
		get_tree().change_scene_to_file("res://Levels/CustomLevel.tscn")
	
	await get_tree().process_frame
	
	StartMenu.level_creator_active = false
	
	level = get_node_or_null("/root/CustomLevel")
	
	if level == null:
		push_error("CustomLevel scene root not found or not named 'CustomLevel'")
		get_tree().paused = false
		return
	else:
		level.is_custom_level = true
	
	level.load_from_data(data)
	
	for c in level.get_children():
		if c is Goal:
			level.goal = c
	
	data_loaded.emit()
	
	if StartMenu.visible and not StartMenu.level_creator_active:
		StartMenu.levels_background.visible = false
		StartMenu.visible = false
		StartMenu.game_started = true
	
	level_loaded.emit()
	
	await SceneTransition.fade_in()
	get_tree().paused = false
