extends CanvasLayer

signal trash
signal ok
signal returning_to_start
signal return_to_start_complete

const LOCK_ICON := preload("res://GUI/PauseMenu/lock.png")

@onready var button_reset: Button = $ButtonReset
@onready var button_start: Button = $VBoxContainer/VBoxContainer/ButtonStart
@onready var h_slider_music: HSlider = $VBoxContainer/VBoxContainer/HSliderMusic
@onready var h_slider_sound: HSlider = $VBoxContainer/VBoxContainer/HSliderSound
@onready var button_01: Button = $VBoxContainer/HBoxContainer1/Button_01
@onready var button_02: Button = $VBoxContainer/HBoxContainer1/Button_02
@onready var button_03: Button = $VBoxContainer/HBoxContainer1/Button_03
@onready var button_04: Button = $VBoxContainer/HBoxContainer1/Button_04
@onready var button_05: Button = $VBoxContainer/HBoxContainer1/Button_05
@onready var button_06: Button = $VBoxContainer/HBoxContainer2/Button_06
@onready var button_07: Button = $VBoxContainer/HBoxContainer2/Button_07
@onready var button_08: Button = $VBoxContainer/HBoxContainer2/Button_08
@onready var button_09: Button = $VBoxContainer/HBoxContainer2/Button_09
@onready var button_10: Button = $VBoxContainer/HBoxContainer2/Button_10
@onready var button_11: Button = $VBoxContainer/HBoxContainer3/Button_11
@onready var button_12: Button = $VBoxContainer/HBoxContainer3/Button_12
@onready var button_13: Button = $VBoxContainer/HBoxContainer3/Button_13
@onready var button_14: Button = $VBoxContainer/HBoxContainer3/Button_14
@onready var button_15: Button = $VBoxContainer/HBoxContainer3/Button_15
@onready var button_16: Button = $VBoxContainer/HBoxContainer4/Button_16
@onready var button_17: Button = $VBoxContainer/HBoxContainer4/Button_17
@onready var button_18: Button = $VBoxContainer/HBoxContainer4/Button_18
@onready var button_19: Button = $VBoxContainer/HBoxContainer4/Button_19
@onready var button_20: Button = $VBoxContainer/HBoxContainer4/Button_20
@onready var button_21: Button = $VBoxContainer/HBoxContainer5/Button_21
@onready var button_22: Button = $VBoxContainer/HBoxContainer5/Button_22
@onready var button_23: Button = $VBoxContainer/HBoxContainer5/Button_23
@onready var button_24: Button = $VBoxContainer/HBoxContainer5/Button_24
@onready var button_25: Button = $VBoxContainer/HBoxContainer5/Button_25

@onready var custom_container: VBoxContainer = $VBoxContainer2
@onready var button_c_1: Button = $VBoxContainer2/HBoxContainer/Button_C1
@onready var button_c_2: Button = $VBoxContainer2/HBoxContainer/Button_C2
@onready var button_c_3: Button = $VBoxContainer2/HBoxContainer/Button_C3
@onready var button_c_4: Button = $VBoxContainer2/HBoxContainer2/Button_C4
@onready var button_c_5: Button = $VBoxContainer2/HBoxContainer2/Button_C5
@onready var button_c_6: Button = $VBoxContainer2/HBoxContainer2/Button_C6
@onready var button_c_7: Button = $VBoxContainer2/HBoxContainer3/Button_C7
@onready var button_c_8: Button = $VBoxContainer2/HBoxContainer3/Button_C8
@onready var button_c_9: Button = $VBoxContainer2/HBoxContainer3/Button_C9
@onready var button_blank_1: Button = $VBoxContainer2/HBoxContainer/Button_BLANK1
@onready var button_blank_2: Button = $VBoxContainer2/HBoxContainer/Button_BLANK2
@onready var button_blank_3: Button = $VBoxContainer2/HBoxContainer/Button_BLANK3
@onready var button_blank_4: Button = $VBoxContainer2/HBoxContainer2/Button_BLANK4
@onready var button_blank_5: Button = $VBoxContainer2/HBoxContainer2/Button_BLANK5
@onready var button_blank_6: Button = $VBoxContainer2/HBoxContainer2/Button_BLANK6
@onready var button_blank_7: Button = $VBoxContainer2/HBoxContainer3/Button_BLANK7
@onready var button_blank_8: Button = $VBoxContainer2/HBoxContainer3/Button_BLANK8
@onready var button_blank_9: Button = $VBoxContainer2/HBoxContainer3/Button_BLANK9

@onready var trash_1: Button = $VBoxContainer2/HBoxContainer/Button_C1/Trash
@onready var trash_2: Button = $VBoxContainer2/HBoxContainer/Button_C2/Trash
@onready var trash_3: Button = $VBoxContainer2/HBoxContainer/Button_C3/Trash
@onready var trash_4: Button = $VBoxContainer2/HBoxContainer2/Button_C4/Trash
@onready var trash_5: Button = $VBoxContainer2/HBoxContainer2/Button_C5/Trash
@onready var trash_6: Button = $VBoxContainer2/HBoxContainer2/Button_C6/Trash
@onready var trash_7: Button = $VBoxContainer2/HBoxContainer3/Button_C7/Trash
@onready var trash_8: Button = $VBoxContainer2/HBoxContainer3/Button_C8/Trash
@onready var trash_9: Button = $VBoxContainer2/HBoxContainer3/Button_C9/Trash
@onready var button_yes: Button = $TrashPopup/MarginContainer/VBoxContainer/ButtonYes
@onready var button_no: Button = $TrashPopup/MarginContainer/VBoxContainer/ButtonNo
@onready var control_1: Control = $Control1
@onready var control_2: Control = $Control2
@onready var trash_popup: PanelContainer = $TrashPopup
@onready var cannot_delete_popup: PanelContainer = $CannotDeletePopup
@onready var button_ok: Button = $CannotDeletePopup/MarginContainer/VBoxContainer/ButtonOK

var is_paused : bool = false
var level_selected : bool = false
var c_buttons : Array[Button]
var c_blanks : Array[Button]
var trash_it : bool = false
var popup_visible : bool = false

func _ready() -> void:
	for btn in get_tree().get_nodes_in_group("pause_menu_buttons"):
		if not btn.pressed.is_connected(_on_button_pressed.bind(btn)):
			btn.pressed.connect(_on_button_pressed.bind(btn))
	
	if not button_start.pressed.is_connected(_on_button_pressed.bind(button_start)):
		button_start.pressed.connect(_on_button_pressed.bind(button_start))
	if not button_yes.pressed.is_connected(_on_trash_yes):
		button_yes.pressed.connect(_on_trash_yes)
	if not button_no.pressed.is_connected(_on_trash_no):
		button_no.pressed.connect(_on_trash_no)
	if not button_ok.pressed.is_connected(_on_ok):
		button_ok.pressed.connect(_on_ok)
	
	if not h_slider_music.value_changed.is_connected(on_music_value_changed):
		h_slider_music.value_changed.connect(on_music_value_changed)
	if not h_slider_sound.value_changed.is_connected(_on_sound_value_changed):
		h_slider_sound.value_changed.connect(_on_sound_value_changed)
	if not h_slider_sound.drag_ended.is_connected(_on_sound_drag_release):
		h_slider_sound.drag_ended.connect(_on_sound_drag_release)
	
	c_buttons = [
		button_c_1,
		button_c_2,
		button_c_3,
		button_c_4,
		button_c_5,
		button_c_6,
		button_c_7,
		button_c_8,
		button_c_9,
	]
	c_blanks = [
		button_blank_1,
		button_blank_2,
		button_blank_3,
		button_blank_4,
		button_blank_5,
		button_blank_6,
		button_blank_7,
		button_blank_8,
		button_blank_9,
	]
	
	update_buttons()
	hide_pause_menu()

func _process(_delta: float) -> void:
	if not StartMenu.game_started:
		button_reset.visible = false
	else:
		button_reset.visible = true

func on_music_value_changed(_v : float) -> void:
	if _v == h_slider_music.min_value:
		AudioManager.music_creator.volume_db = -80
		AudioManager.music_levels_1.volume_db = -80
		AudioManager.music_levels_2.volume_db = -80
		AudioManager.music_levels_3.volume_db = -80
		AudioManager.music_levels_4.volume_db = -80
		AudioManager.music_start.volume_db = -80
	else:
		AudioManager.music_creator.volume_db = _v
		AudioManager.music_levels_1.volume_db = _v
		AudioManager.music_levels_2.volume_db = _v
		AudioManager.music_levels_3.volume_db = _v
		AudioManager.music_levels_4.volume_db = _v
		AudioManager.music_start.volume_db = _v

func _on_sound_value_changed(_v : float) -> void:
	if _v == h_slider_sound.min_value:
		for s in get_tree().get_nodes_in_group("sounds"):
			s.volume_db = -80
	else:
		for s in get_tree().get_nodes_in_group("sounds"):
			s.volume_db = _v

func _on_sound_drag_release(_value : float) -> void:
	AudioManager.jump.pitch_scale = randf_range(0.95, 1.05)
	AudioManager.jump.play()

func update_buttons() -> void:
	for btn in get_tree().get_nodes_in_group("pause_menu_buttons"):
		if (
			btn.get_parent().get_parent() != custom_container 
			and btn.get_parent().get_parent().get_parent() != custom_container
			and btn != button_start
			and btn != button_reset
			):
				if btn == button_start:
					continue
				var locked := true
				for i in SaveManager.unlocked_levels:
					var level := int(btn.name.get_slice("_", 1))
					if i == level:
						btn.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
						btn.icon = null
						locked = false
				if locked and btn != button_reset and btn != button_start:
					btn.icon = LOCK_ICON
					btn.self_modulate = Color(0.299, 0.336, 0.391, 1.0)
		else:
			if custom_container == null:
				custom_container = get_node("VBoxContainer2")
			var any_visible : bool = false
			for i in range(c_buttons.size()):
				var file_path := "user://levels/C" + str(i + 1) + ".json"
				var exists := FileAccess.file_exists(file_path)
				c_buttons[i].visible = exists
				c_blanks[i].visible = !exists
				if exists:
					any_visible = true
			custom_container.visible = any_visible

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and (StartMenu.game_started or StartMenu.level_creator_active or StartMenu.test_mode) and !popup_visible:
		if not is_paused:
			show_pause_menu()
		else:
			hide_pause_menu()
		get_viewport().set_input_as_handled()

func show_pause_menu() -> void:
	get_tree().paused = true
	visible = true
	is_paused = true

func hide_pause_menu() -> void:
	get_tree().paused = false
	visible = false
	is_paused = false
	StartMenu.levels_showing = false

func return_to_start() -> void:
	var c := get_tree().current_scene
	if c != null:
		if c.name.begins_with("@CanvasLayer@"):
			hide_pause_menu()
			c.levels_background.visible = false
			return
	await SceneTransition.fade_out()
	returning_to_start.emit()
	visible = false
	is_paused = false
	StartMenu.visible = true
	get_tree().change_scene_to_file("res://GUI/StartMenu/start_menu.tscn")
	await SceneTransition.fade_in()
	for n in get_tree().get_nodes_in_group("level_creator"):
		if n is LevelCreator:
			n.queue_free()
	return_to_start_complete.emit()

func _on_ok() -> void:
	ok.emit()

func show_cannot_delete_popup() -> void:
	popup_visible = true
	cannot_delete_popup.visible = true
	control_1.mouse_filter = Control.MOUSE_FILTER_STOP
	control_2.mouse_filter = Control.MOUSE_FILTER_STOP
	await ok
	control_1.mouse_filter = Control.MOUSE_FILTER_IGNORE
	control_2.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cannot_delete_popup.visible = false
	popup_visible = false

func show_trash_popup(btn : Button) -> void:
	popup_visible = true
	control_1.mouse_filter = Control.MOUSE_FILTER_STOP
	control_2.mouse_filter = Control.MOUSE_FILTER_STOP
	trash_popup.visible = true
	await trash
	if trash_it:
		var sliced_name := btn.name.get_slice("_", 1)
		var file_path := "user://levels/" + sliced_name + ".json"
		if FileAccess.file_exists(file_path):
			DirAccess.remove_absolute(file_path)
		else:
			push_error("Error: Tried to delete " + file_path + " but it does not exist.")
		update_buttons()
		control_1.mouse_filter = Control.MOUSE_FILTER_IGNORE
		control_2.mouse_filter = Control.MOUSE_FILTER_IGNORE
		trash_popup.visible = false
		popup_visible = false
		trash_it = false

func _on_trash_yes() -> void:
	trash_it = true
	trash.emit()

func _on_trash_no() -> void:
	control_1.mouse_filter = Control.MOUSE_FILTER_IGNORE
	control_2.mouse_filter = Control.MOUSE_FILTER_IGNORE
	trash_popup.visible = false
	popup_visible = false
	trash_it = false
	trash.emit()

func _on_button_pressed(btn : Button) -> void:
	if btn == button_reset:
		hide_pause_menu()
		if LevelManager.custom_level_mode:
			LevelManager.load_custom_level(LevelManager.custom_level_file_path)
		else:
			LevelManager.load_new_level(LevelManager.current_level)
	
	elif btn == button_start:
		LevelManager.custom_level_mode = false
		return_to_start()
	
	elif btn.get_parent().get_parent() == custom_container: # Custom Levels
		hide_pause_menu()
		var sliced_name := btn.name.get_slice("_", 1)
		var file_path := "user://levels/" + sliced_name + ".json"
		LevelManager.load_custom_level(file_path)
	
	elif btn.get_parent().get_parent().get_parent() == custom_container: # Trash Cans
		var sliced_name := btn.get_parent().name.get_slice("_", 1)
		var file_path := "user://levels/" + sliced_name + ".json"
		if LevelManager.custom_level_file_path == file_path:
			show_cannot_delete_popup()
		else:
			show_trash_popup(btn.get_parent())
	
	else:
		LevelManager.custom_level_mode = false
		var level := int(btn.name.get_slice("_", 1))
		for i in SaveManager.unlocked_levels:
			if i == level:
				if StartMenu.visible:
					StartMenu.levels_background.visible = false
				level_selected = true
				hide_pause_menu()
				LevelManager.load_new_level(level)
				level_selected = false
				StartMenu.game_started = true
