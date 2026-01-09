@tool
class_name ButtonDoor extends RigidBody2D

signal door_button_connector_pressed

@onready var panel_container_vertical: PanelContainer = $PanelContainerVertical
@onready var button_rotate: Button = $PanelContainerVertical/VBoxContainer/ButtonRotate
@onready var button_hinge: Button = $PanelContainerVertical/VBoxContainer/ButtonHinge
@onready var button_open_dir: Button = $PanelContainerVertical/VBoxContainer/ButtonOpenDir
@onready var button_expand: Button = $PanelContainerVertical/VBoxContainer/ButtonExpand
@onready var button_contract: Button = $PanelContainerVertical/VBoxContainer/ButtonContract
@onready var button_button: Button = $PanelContainerVertical/VBoxContainer/ButtonButton
@onready var panel_container_horizontal: PanelContainer = $PanelContainerHorizontal
@onready var button_rotate_2: Button = $PanelContainerHorizontal/VBoxContainer/ButtonRotate2
@onready var button_hinge_2: Button = $PanelContainerHorizontal/VBoxContainer/ButtonHinge2
@onready var button_open_dir_2: Button = $PanelContainerHorizontal/VBoxContainer/ButtonOpenDir2
@onready var button_expand_2: Button = $PanelContainerHorizontal/VBoxContainer/ButtonExpand2
@onready var button_contract_2: Button = $PanelContainerHorizontal/VBoxContainer/ButtonContract2
@onready var button_button_2: Button = $PanelContainerHorizontal/VBoxContainer/ButtonButton2
@onready var door_arrow: Sprite2D = $CollisionShape2D/DoorArrow
@onready var button_visualizer: Sprite2D = $CollisionShape2D/ButtonVisualizer
@onready var hinge_locator: Sprite2D = $HingeLocator

const BUTTON_O = preload("uid://cc3k55pdgpm31")
const BUTTON_X = preload("uid://b36ixypn56jla")
const DOOR_ARROW = preload("uid://dijylx0s6wo85")
const DOOR_OPEN_LEFT = preload("uid://iphoaxy73t6n")
const DOOR_OPEN_RIGHT = preload("uid://dh8la40knq783")
const HINGE_BUTTON_ICON_0 = preload("uid://bmax1p6i215a")
const HINGE_BUTTON_ICON_90 = preload("uid://vdvdh15kkkhw")
const HINGE_BUTTON_ICON_180 = preload("uid://dandh6eu4u845")
const HINGE_BUTTON_ICON_270 = preload("uid://gghfedskft0p")

@onready var mouse_area: Area2D = $MouseArea
@onready var mouse_collision: CollisionShape2D = $MouseArea/CollisionShape2D
var mouse_captured : bool = false

enum SIDE {VERTICAL, HORIZONTAL}
enum DIR {CW, CCW}
enum ORIGIN {TOP_LEFT, TOP_RIGHT, BOTTOM_LEFT, BOTTOM_RIGHT}

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var default_size := Vector2(1, 1)
var distance := 50
var line_color : Color = Color(0.0, 0.906, 1.0, 1.0)
var line_color_blue : Color = Color(0.0, 0.906, 1.0, 1.0)
var line_color_red : Color = Color(0.553, 0.0, 0.0, 1.0)
var panel_container_vertical_offset : Vector2 = Vector2(11, -82)
var panel_container_horizontal_offset : Vector2 = Vector2(-83, -43)
var button_x : float
var button_y : float

@export_category("Scene Settings")
@export var button : MyButton
@export var opening_dir : DIR = DIR.CW
@export var origin : ORIGIN = ORIGIN.TOP_LEFT :
	set(_v):
		origin = _v
		_update_area()

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

func _enter_tree() -> void:
	if Engine.is_editor_hint():
		set_process(true)

func _ready() -> void:
	if collision_shape and collision_shape.shape:
		collision_shape.shape = collision_shape.shape.duplicate()
	_update_area()
	
	if Engine.is_editor_hint():
		set_process(true)
		return
	if StartMenu.level_creator_active:
		collision_shape.visible = true
		hinge_locator.visible = true
		mouse_area.visible = true
		panel_container_vertical.visible = true
		connect_creator_buttons()
		return
	
	if not button or !is_instance_valid(button):
		return
	if not button.button_signal.is_connected(_open_door):
		button.button_signal.connect(_open_door)
	if not body_entered.is_connected(_player_entered):
		body_entered.connect(_player_entered)

func _process(_delta: float) -> void:
	if Engine.is_editor_hint() or StartMenu.level_creator_active:
		queue_redraw()

func _player_entered(_p : Player) -> void:
	pass

func _update_area() -> void:
	if not Engine.is_editor_hint() and !StartMenu.level_creator_active:
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
	
	match origin:
		ORIGIN.TOP_LEFT:
			collision_shape.position = Vector2(new_rect.x / 2, new_rect.y / 2)
			sprite.position = Vector2(new_rect.x / 2, new_rect.y / 2)
		ORIGIN.TOP_RIGHT:
			collision_shape.position = Vector2(-new_rect.x / 2, new_rect.y / 2)
			sprite.position = Vector2(-new_rect.x / 2, new_rect.y / 2)
		ORIGIN.BOTTOM_LEFT:
			collision_shape.position = Vector2(new_rect.x / 2, -new_rect.y / 2)
			sprite.position = Vector2(new_rect.x / 2, -new_rect.y / 2)
		ORIGIN.BOTTOM_RIGHT:
			collision_shape.position = Vector2(-new_rect.x / 2, -new_rect.y / 2)
			sprite.position = Vector2(-new_rect.x / 2, -new_rect.y / 2)
	
	mouse_area.position = collision_shape.position

func _snap_to_grid() -> void:
	position.x = round(position.x / 8) * 8
	position.y = round(position.y / 8) * 8

func _open_door() -> void:
	match opening_dir:
		DIR.CW:
			animation_player.play("open_door_cw")
		DIR.CCW:
			animation_player.play("open_door_ccw")

func _draw() -> void:
	if not Engine.is_editor_hint():
		return
	if not button or !is_instance_valid(button):
		return
	
	var from : Vector2 = to_local(sprite.global_position)
	var to : Vector2 = to_local(button.color_rect_red.global_position)
	
	draw_line(from, to, line_color, 2.0)

func _update_menu() -> void:
	if side == SIDE.VERTICAL:
		panel_container_vertical.visible = true
		panel_container_horizontal.visible = false
		panel_container_vertical.position = collision_shape.position + panel_container_vertical_offset
	else:
		panel_container_vertical.visible = false
		panel_container_horizontal.visible = true
		panel_container_horizontal.position = collision_shape.position + panel_container_horizontal_offset

func _on_rotate_pressed() -> void:
	if side == SIDE.VERTICAL:
		side = SIDE.HORIZONTAL
		if panel_container_vertical.visible:
			panel_container_vertical.visible = false
			panel_container_horizontal.visible = true
		door_arrow.rotation_degrees -= 90
	elif side == SIDE.HORIZONTAL:
		side = SIDE.VERTICAL
		if panel_container_horizontal.visible:
			panel_container_horizontal.visible = false
			panel_container_vertical.visible = true
		door_arrow.rotation_degrees += 90
	_update_area()
	_snap_to_grid()
	_update_menu()

func _on_hinge_pressed() -> void:
	if origin == ORIGIN.TOP_LEFT:
		origin = ORIGIN.TOP_RIGHT
		button_hinge.icon = HINGE_BUTTON_ICON_90
		button_hinge_2.icon = HINGE_BUTTON_ICON_90
		global_position.x += collision_shape.shape.size.x
	elif origin == ORIGIN.TOP_RIGHT:
		origin = ORIGIN.BOTTOM_RIGHT
		button_hinge.icon = HINGE_BUTTON_ICON_180
		button_hinge_2.icon = HINGE_BUTTON_ICON_180
		global_position.y += collision_shape.shape.size.y
	elif origin == ORIGIN.BOTTOM_RIGHT:
		origin = ORIGIN.BOTTOM_LEFT
		button_hinge.icon = HINGE_BUTTON_ICON_270
		button_hinge_2.icon = HINGE_BUTTON_ICON_270
		global_position.x -= collision_shape.shape.size.x
	elif origin == ORIGIN.BOTTOM_LEFT:
		origin = ORIGIN.TOP_LEFT
		button_hinge.icon = HINGE_BUTTON_ICON_0
		button_hinge_2.icon = HINGE_BUTTON_ICON_0
		global_position.y -= collision_shape.shape.size.y
	_update_area()
	_snap_to_grid()
	_update_menu()

func _on_open_dir_pressed() -> void:
	if opening_dir == DIR.CW:
		opening_dir = DIR.CCW
		button_open_dir.icon = DOOR_OPEN_RIGHT
		button_open_dir_2.icon = DOOR_OPEN_RIGHT
	else:
		opening_dir = DIR.CW
		button_open_dir.icon = DOOR_OPEN_LEFT
		button_open_dir_2.icon = DOOR_OPEN_LEFT
	door_arrow.scale.x *= -1

func _on_expand_pressed() -> void:
	size += 1
	size = clampi(size, 1, 20)
	_update_area()
	_snap_to_grid()
	_update_menu()

func _on_contract_pressed() -> void:
	size -= 1
	size = clampi(size, 1, 20)
	_update_area()
	_snap_to_grid()
	_update_menu()

func _on_button_pressed() -> void:
	door_button_connector_pressed.emit()

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
	if not button_hinge.pressed.is_connected(_on_hinge_pressed):
		button_hinge.pressed.connect(_on_hinge_pressed)
	if not button_open_dir.pressed.is_connected(_on_open_dir_pressed):
		button_open_dir.pressed.connect(_on_open_dir_pressed)
	if not button_expand.pressed.is_connected(_on_expand_pressed):
		button_expand.pressed.connect(_on_expand_pressed)
	if not button_contract.pressed.is_connected(_on_contract_pressed):
		button_contract.pressed.connect(_on_contract_pressed)
	if not button_button.pressed.is_connected(_on_button_pressed):
		button_button.pressed.connect(_on_button_pressed)
	if not button_rotate_2.pressed.is_connected(_on_rotate_pressed):
		button_rotate_2.pressed.connect(_on_rotate_pressed)
	if not button_hinge_2.pressed.is_connected(_on_hinge_pressed):
		button_hinge_2.pressed.connect(_on_hinge_pressed)
	if not button_open_dir_2.pressed.is_connected(_on_open_dir_pressed):
		button_open_dir_2.pressed.connect(_on_open_dir_pressed)
	if not button_expand_2.pressed.is_connected(_on_expand_pressed):
		button_expand_2.pressed.connect(_on_expand_pressed)
	if not button_contract_2.pressed.is_connected(_on_contract_pressed):
		button_contract_2.pressed.connect(_on_contract_pressed)
	if not button_button_2.pressed.is_connected(_on_button_pressed):
		button_button_2.pressed.connect(_on_button_pressed)
