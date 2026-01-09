extends CanvasLayer

signal fade_in_complete

@onready var control: Control = $Control
@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer
@onready var rect: ColorRect = $Control/ColorRect
@onready var loading_screen: ColorRect = $LoadingScreen
@onready var progress_bar: ProgressBar = $LoadingScreen/ProgressBar

var goal_pos : Vector2
var viewport_size : Vector2

func _ready() -> void:
	control.visible = false
	update_viewport_size()

func fade_out() -> bool:
	if control == null:
		control = $Control
	if animation_player == null:
		animation_player = $Control/AnimationPlayer
	
	control.visible = true
	
	var scene := get_tree().current_scene
	
	if scene is not Level:
		animation_player.play("circle_in_start")
	elif not scene.completed:
		animation_player.play("circle_in_start")
	else:
		animation_player.play("circle_in")
	await animation_player.animation_finished
	return true

func fade_in() -> bool:
	animation_player.play("circle_out")
	if SaveManager.game_loaded:
		AudioManager.check_scene_and_play()
	await animation_player.animation_finished
	control.visible = false
	fade_in_complete.emit()
	return true

func set_transition_pos() -> void:
	if StartMenu.game_started == false or StartMenu.level_creator_active:
		goal_pos = viewport_size / 2
	else:
		if LevelManager.custom_level_mode:
			await LevelManager.data_loaded
		if LevelManager.level == null:
			goal_pos = viewport_size / 2
		else:
			goal_pos = LevelManager.level.goal.position
	var parameter : Vector2 = goal_pos / viewport_size
	rect.material.set_shader_parameter("center_uv", parameter)

func update_viewport_size() -> void:
	viewport_size = control.get_viewport_rect().size

func load_game_from_start() -> void:
	loading_screen.visible = true
	SaveManager._load_game_from_start()
	await SaveManager.game_load_1
	progress_bar.value = 30
	await SaveManager.game_load_2
	progress_bar.value = 60
	await SaveManager.game_load_3
	progress_bar.value = 90
	loading_screen.queue_free()
	SaveManager.game_loaded = true
