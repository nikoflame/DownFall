@tool
class_name BreakableWall extends RigidBody2D

enum SIDE {VERTICAL, HORIZONTAL}

@onready var panel_container_vertical: PanelContainer = $PanelContainerVertical
@onready var button_rotate: Button = $PanelContainerVertical/VBoxContainer/ButtonRotate
@onready var button_expand: Button = $PanelContainerVertical/VBoxContainer/ButtonExpand
@onready var button_contract: Button = $PanelContainerVertical/VBoxContainer/ButtonContract
@onready var panel_container_horizontal: PanelContainer = $PanelContainerHorizontal
@onready var button_rotate_2: Button = $PanelContainerHorizontal/VBoxContainer/ButtonRotate2
@onready var button_expand_2: Button = $PanelContainerHorizontal/VBoxContainer/ButtonExpand2
@onready var button_contract_2: Button = $PanelContainerHorizontal/VBoxContainer/ButtonContract2


@onready var mouse_area: Area2D = $MouseArea
@onready var mouse_collision: CollisionShape2D = $MouseArea/CollisionShape2D
var mouse_captured : bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var default_size := Vector2(1, 1)
var distance := 50

@export_category("Collision Area Settings")
@export_range(1, 12, 1, "or_greater") var size : int = 3 :
	set(_v):
		size = _v
		_update_area()
@export var side: SIDE = SIDE.VERTICAL :
	set(_v):
		side = _v
		_update_area()
@export var snap_to_grid := false :
	set(_v):
		_snap_to_grid()

func _ready() -> void:
	if collision_shape and collision_shape.shape:
		collision_shape.shape = collision_shape.shape.duplicate()
	_update_area()
	
	if Engine.is_editor_hint():
		return
	if StartMenu.level_creator_active:
		collision_shape.visible = true
		mouse_area.visible = true
		panel_container_vertical.visible = true
		connect_creator_buttons()
		return
	
	if not body_entered.is_connected(_player_entered):
		body_entered.connect(_player_entered)

func _player_entered(_p : Player) -> void:
	pass

func _update_area() -> void:
	if not Engine.is_editor_hint() and not StartMenu.level_creator_active:
		await LevelManager.level_loaded
	
	get_null_nodes()
	
	var new_rect : Vector2 = Vector2(16, 16)
	
	sprite.scale = default_size
	
	if side == SIDE.VERTICAL:
		new_rect.y *= size
		sprite.scale.y *= size
	elif side == SIDE.HORIZONTAL:
		new_rect.x *= size
		sprite.scale.x *= size
	
	collision_shape.shape.size = new_rect
	mouse_collision.shape.size = new_rect

func _snap_to_grid() -> void:
	position.x = round(position.x / 8) * 8
	position.y = round(position.y / 8) * 8

func find_explosion(_p : Player) -> void:
	var my_pos := [
		global_position,
		Vector2(global_position.x, global_position.y - (collision_shape.shape.size.y / 2)),
		Vector2(global_position.x, global_position.y + (collision_shape.shape.size.y / 2)),
		Vector2(global_position.x - (collision_shape.shape.size.x / 2), global_position.y),
		Vector2(global_position.x + (collision_shape.shape.size.x / 2), global_position.y),
		]
	if (
		_p.global_position.distance_to(my_pos[0]) <= distance
		or _p.global_position.distance_to(my_pos[1]) <= distance
		or _p.global_position.distance_to(my_pos[2]) <= distance
		or _p.global_position.distance_to(my_pos[3]) <= distance
		or _p.global_position.distance_to(my_pos[4]) <= distance
		):
			queue_free()
		

func _on_rotate_pressed() -> void:
	if side == SIDE.VERTICAL:
		side = SIDE.HORIZONTAL
		if panel_container_vertical.visible:
			panel_container_vertical.visible = false
			panel_container_horizontal.visible = true
	elif side == SIDE.HORIZONTAL:
		side = SIDE.VERTICAL
		if panel_container_horizontal.visible:
			panel_container_horizontal.visible = false
			panel_container_vertical.visible = true
	_update_area()
	_snap_to_grid()

func _on_expand_pressed() -> void:
	size += 1
	size = clampi(size, 1, 20)
	_update_area()
	_snap_to_grid()

func _on_contract_pressed() -> void:
	size -= 1
	size = clampi(size, 1, 20)
	_update_area()
	_snap_to_grid()

func _on_mouse_entered() -> void:
	mouse_captured = true

func _on_mouse_exited() -> void:
	mouse_captured = false

func get_null_nodes() -> void:
	if sprite == null:
		sprite = get_node("Sprite2D")
	if collision_shape == null:
		collision_shape = get_node("CollisionShape2D")
	if mouse_area == null:
		mouse_area = get_node("MouseArea")
	if mouse_collision == null:
		mouse_collision = get_node("MouseArea/CollisionShape2D")

func connect_creator_buttons() -> void:
	if not mouse_area.mouse_entered.is_connected(_on_mouse_entered):
		mouse_area.mouse_entered.connect(_on_mouse_entered)
	if not mouse_area.mouse_exited.is_connected(_on_mouse_exited):
		mouse_area.mouse_exited.connect(_on_mouse_exited)
	if not button_rotate.pressed.is_connected(_on_rotate_pressed):
		button_rotate.pressed.connect(_on_rotate_pressed)
	if not button_expand.pressed.is_connected(_on_expand_pressed):
		button_expand.pressed.connect(_on_expand_pressed)
	if not button_contract.pressed.is_connected(_on_contract_pressed):
		button_contract.pressed.connect(_on_contract_pressed)
	if not button_rotate_2.pressed.is_connected(_on_rotate_pressed):
		button_rotate_2.pressed.connect(_on_rotate_pressed)
	if not button_expand_2.pressed.is_connected(_on_expand_pressed):
		button_expand_2.pressed.connect(_on_expand_pressed)
	if not button_contract_2.pressed.is_connected(_on_contract_pressed):
		button_contract_2.pressed.connect(_on_contract_pressed)
