extends Node

const USER_SAVE_PATH = "user://saves"

signal game_saved
signal game_reset
signal game_load_1
signal game_load_2
signal game_load_3
signal game_load_done

var unlocked_levels = [1, 2, 3]
var game_loaded : bool = true

func _ready() -> void:
	load_game()

func save_game() -> void:
	var file := FileAccess.open(USER_SAVE_PATH + "/save.sav", FileAccess.WRITE)
	var save_json := JSON.stringify(unlocked_levels)
	file.store_line(save_json)
	game_saved.emit()

func reset_game() -> void:
	unlocked_levels = [01, 02, 03]
	save_game()
	
	PauseMenu.update_buttons()
	
	await SceneTransition.fade_out()
	
	PauseMenu.return_to_start()
	
	await SceneTransition.fade_in()
	
	game_reset.emit()

func load_game() -> void:
	if not FileAccess.file_exists(USER_SAVE_PATH + "/save.sav"):
		DirAccess.make_dir_recursive_absolute(USER_SAVE_PATH)
		save_game()
	var file := FileAccess.open(USER_SAVE_PATH + "/save.sav", FileAccess.READ)
	var json := JSON.new()
	json.parse(file.get_line())
	var save_arr : Array = json.get_data() as Array
	unlocked_levels = save_arr
	
	PauseMenu.update_buttons()

func _load_game_from_start() -> void:
	StartMenu._on_creator_pressed()
	await StartMenu.creator_load_finished
	await get_tree().create_timer(3).timeout
	game_load_1.emit()
	var creator := get_tree().current_scene
	creator._on_return_to_start_popup_yes()
	await PauseMenu.returning_to_start
	game_load_2.emit()
	await PauseMenu.return_to_start_complete
	await get_tree().create_timer(1.5).timeout
	game_load_3.emit()
	game_load_done.emit()
