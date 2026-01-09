@tool
class_name Goal extends RigidBody2D

@onready var area: Area2D = $Area2D

@onready var mouse_area: Area2D = $MouseArea
var mouse_captured : bool = false

@export var snap_to_grid := false :
	set(_v):
		_snap_to_grid()

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	if StartMenu.level_creator_active:
		if not mouse_area.mouse_entered.is_connected(_on_mouse_entered):
			mouse_area.mouse_entered.connect(_on_mouse_entered)
		if not mouse_area.mouse_exited.is_connected(_on_mouse_exited):
			mouse_area.mouse_exited.connect(_on_mouse_exited)
		mouse_area.visible = true
		return
	
	if not area.goal.is_connected(goal_reached):
		area.goal.connect(goal_reached)

func goal_reached() -> void:
	var scene := get_tree().current_scene
	if scene is Level:
		if not scene.completed:
			scene.completed = true
	Selection.visible = false
	AudioManager.goal.pitch_scale = randf_range(0.95, 1.05)
	AudioManager.goal.play()
	await get_tree().create_timer(0.1).timeout
	if LevelManager.custom_level_mode or LevelManager.current_level == LevelManager.max_levels:
		if StartMenu.test_mode:
			StartMenu.game_started = false
			LevelManager.return_to_level_creator()
		else:
			PauseMenu.return_to_start()
	else:
		LevelManager.load_next_level()

func _snap_to_grid() -> void:
	position.x = round(position.x / 8) * 8
	position.y = round(position.y / 8) * 8

func _on_mouse_entered() -> void:
	mouse_captured = true

func _on_mouse_exited() -> void:
	mouse_captured = false
