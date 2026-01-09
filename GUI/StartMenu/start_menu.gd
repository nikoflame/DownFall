extends CanvasLayer

signal creator_load_finished
signal drop_finished

@onready var button_start: Button = $HBoxContainer/VBoxContainer/ButtonStart
@onready var button_load: Button = $HBoxContainer/VBoxContainer/ButtonLoad
@onready var button_creator: Button = $HBoxContainer/VBoxContainer2/ButtonCreator
@onready var button_reset: Button = $ButtonReset
@onready var levels_background: VBoxContainer = $VBoxContainer2
@onready var d_ap: AnimationPlayer = $TitleSprites/DSprite/AnimationPlayer
@onready var o_ap: AnimationPlayer = $TitleSprites/OSprite/AnimationPlayer
@onready var w_ap: AnimationPlayer = $TitleSprites/WSprite/AnimationPlayer
@onready var n_ap: AnimationPlayer = $TitleSprites/NSprite/AnimationPlayer
@onready var f_ap: AnimationPlayer = $TitleSprites/FSprite/AnimationPlayer
@onready var a_ap: AnimationPlayer = $TitleSprites/ASprite/AnimationPlayer
@onready var l1_ap: AnimationPlayer = $TitleSprites/L1Sprite/AnimationPlayer
@onready var l2_ap: AnimationPlayer = $TitleSprites/L2Sprite/AnimationPlayer

var game_started : bool = false
var levels_showing : bool = false
var drop_time : float = 0.4
var title_sequence_started : bool = false
var level_creator_active : bool = false
var test_mode : bool = false

func _ready() -> void:
	if not button_start.pressed.is_connected(_on_start_pressed):
		button_start.pressed.connect(_on_start_pressed)
	if not button_load.pressed.is_connected(_on_load_pressed):
		button_load.pressed.connect(_on_load_pressed)
	if not button_creator.pressed.is_connected(_on_creator_pressed):
		button_creator.pressed.connect(_on_creator_pressed)
	if not button_reset.pressed.is_connected(_on_reset_pressed):
		button_reset.pressed.connect(_on_reset_pressed)
	
	if get_tree().current_scene != self and not SaveManager.game_loaded:
		SceneTransition.load_game_from_start()
		await SaveManager.game_load_done
	elif not SaveManager.game_loaded:
		await SaveManager.game_load_done
	
	get_tree().paused = true
	
	await get_tree().create_timer(0.5).timeout
	title_sequence_started = true
	d_ap.play("d_drop")
	await get_tree().create_timer(drop_time).timeout
	o_ap.play("o_drop")
	await get_tree().create_timer(drop_time).timeout
	w_ap.play("w_drop")
	await get_tree().create_timer(drop_time).timeout
	n_ap.play("n_drop")
	await get_tree().create_timer(drop_time).timeout
	f_ap.play("f_drop")
	await get_tree().create_timer(drop_time).timeout
	a_ap.play("a_drop")
	await get_tree().create_timer(drop_time).timeout
	l1_ap.play("l1_drop")
	await get_tree().create_timer(drop_time).timeout
	l2_ap.play("l2_drop")
	await l2_ap.animation_finished
	drop_finished.emit()

func _process(_delta: float) -> void:
	pass

func _on_start_pressed() -> void:
	if StartMenu.level_creator_active:
		StartMenu.level_creator_active = false
	StartMenu.visible = false
	StartMenu.game_started = true
	LevelManager.load_new_level(LevelManager.current_level)

func _on_load_pressed() -> void:
	if StartMenu.level_creator_active:
		StartMenu.level_creator_active = false
	StartMenu.levels_showing = true
	levels_background.visible = true
	PauseMenu.show_pause_menu()

func _on_creator_pressed() -> void:
	StartMenu.level_creator_active = true
	await SceneTransition.fade_out()
	if SaveManager.game_loaded:
		StartMenu.visible = false
	StartMenu._on_creator_pressed_2()

func _on_creator_pressed_2() -> void:
	get_tree().change_scene_to_file("res://LevelCreator/level_creator.tscn")
	await SceneTransition.fade_in()
	var n := get_tree().get_nodes_in_group("level_creator")[0]
	if not n.returning_to_start.is_connected(_on_creator_return):
		n.returning_to_start.connect(_on_creator_return)
	get_tree().paused = false
	creator_load_finished.emit()

func _on_creator_return() -> void:
	await get_tree().create_timer(2).timeout
	StartMenu.level_creator_active = false

func _on_reset_pressed() -> void:
	if StartMenu.level_creator_active:
		StartMenu.level_creator_active = false
	SaveManager.reset_game()

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event.is_action_pressed("pause") and StartMenu.levels_showing:
		PauseMenu.hide_pause_menu()
		get_tree().paused = true
		StartMenu.levels_background.visible = false
