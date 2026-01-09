@tool
class_name PlayerSpawn extends Node2D

@onready var mouse_area: Area2D = $MouseArea
var mouse_captured : bool = false

enum TYPE {SQUARE, TRIANGLE, CIRCLE, MOON}
@export var type : TYPE

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
		return
	visible = false
	if PlayerManager.players_spawned == false:
		PlayerManager.players.clear()
		PlayerManager.add_player_instances()
		PlayerManager.players_spawned = true
	for p in PlayerManager.players:
		if p.player_spawned == false:
			PlayerManager.set_player_position(p, global_position)
			match type:
				TYPE.SQUARE:
					p.set_type("Square")
				TYPE.TRIANGLE:
					p.set_type("Triangle")
				TYPE.CIRCLE:
					p.set_type("Circle")
				TYPE.MOON:
					p.set_type("Moon")
					p._create_moon()
			p.player_spawned = true
			break

func _on_mouse_entered() -> void:
	mouse_captured = true

func _on_mouse_exited() -> void:
	mouse_captured = false

func _snap_to_grid() -> void:
	position.x = round(position.x / 8) * 8
	position.y = round(position.y / 8) * 8
