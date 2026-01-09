@tool
class_name MyButton extends RigidBody2D

signal button_signal
signal button_door_connector_pressed

const DOOR_CONNECTED = preload("uid://e8px8xtr1gmk")
const DOOR_NOT_CONNECTED = preload("uid://eff3b2axkj7r")

@onready var mouse_area: Area2D = $MouseArea
var mouse_captured : bool = false

@onready var panel_container_vertical: PanelContainer = $PanelContainerVertical
@onready var panel_container_horizontal: PanelContainer = $PanelContainerHorizontal
@onready var button_rotate: Button = $PanelContainerVertical/VBoxContainer/ButtonRotate
@onready var button_rotate_2: Button = $PanelContainerHorizontal/VBoxContainer/ButtonRotate2
@onready var button_door_connector: Button = $PanelContainerVertical/VBoxContainer/ButtonDoorConnector
@onready var button_door_connector_2: Button = $PanelContainerHorizontal/VBoxContainer/ButtonDoorConnector2

@onready var collision_base: CollisionShape2D = $CollisionShapeBase
@onready var collision_button: CollisionShape2D = $Area2D/CollisionShapeButton
@onready var area_button : Area2D = $Area2D
@onready var color_rect_red: ColorRect = $ColorRectRed
@onready var color_rect_black: ColorRect = $ColorRectBlack
@onready var animation_player: AnimationPlayer = $AnimationPlayer

enum SIDE {UP, DOWN, LEFT, RIGHT}

@export_category("Collision Area Settings")
@export var side: SIDE = SIDE.UP :
	set(_v):
		side = _v
		_update_area()
@export var snap_to_grid := false :
	set(_v):
		_snap_to_grid()

var pressed : bool = false

func _ready() -> void:
	if collision_base and collision_base.shape:
		collision_base.shape = collision_base.shape.duplicate()
	if collision_button and collision_button.shape:
		collision_button.shape = collision_button.shape.duplicate()
	
	_update_area()
	
	if Engine.is_editor_hint():
		return
	if StartMenu.level_creator_active:
		panel_container_vertical.visible = true
		mouse_area.visible = true
		connect_creator_buttons()
		return
	
	contact_monitor = true
	max_contacts_reported = 4
	
	if not area_button.body_entered.is_connected(_on_body_entered):
		area_button.body_entered.connect(_on_body_entered)

func button_pressed() -> void:
	pressed = true
	button_signal.emit()

func _on_body_entered(body: Node) -> void:
	if pressed:
		return
	
	if body is Player:
		match side:
			SIDE.UP:
				animation_player.play("pressed_up")
			SIDE.DOWN:
				animation_player.play("pressed_down")
			SIDE.LEFT:
				animation_player.play("pressed_left")
			SIDE.RIGHT:
				animation_player.play("pressed_right")

func _update_area() -> void:
	if collision_base == null:
		collision_base = get_node("CollisionShapeBase")
	if collision_button == null:
		collision_button = get_node("Area2D/CollisionShapeButton")
	if color_rect_red == null:
		color_rect_red = get_node("ColorRectRed")
	if color_rect_black == null:
		color_rect_black = get_node("ColorRectBlack")
	if mouse_area == null:
		mouse_area = get_node("MouseArea")
	
	if side == SIDE.UP:
		color_rect_red.position = Vector2(-5, -9)
		color_rect_red.rotation_degrees = 0
		color_rect_black.position = Vector2(-8, -6)
		color_rect_black.rotation_degrees = 0
		collision_base.position = Vector2(0, -3)
		collision_base.rotation_degrees = 0
		collision_button.position = Vector2(0, -7.5)
		collision_button.rotation_degrees = 0
	elif side == SIDE.DOWN:
		color_rect_red.position = Vector2(-5, 6)
		color_rect_red.rotation_degrees = 0
		color_rect_black.position = Vector2(-8, 0)
		color_rect_black.rotation_degrees = 0
		collision_base.position = Vector2(0, 3)
		collision_base.rotation_degrees = 0
		collision_button.position = Vector2(0, 7.5)
		collision_button.rotation_degrees = 0
	elif side == SIDE.LEFT:
		color_rect_red.position = Vector2(-6, -5)
		color_rect_red.rotation_degrees = 90
		color_rect_black.position = Vector2(0, -8)
		color_rect_black.rotation_degrees = 90
		collision_base.position = Vector2(-3, 0)
		collision_base.rotation_degrees = 90
		collision_button.position = Vector2(-7.5, 0)
		collision_button.rotation_degrees = 90
	elif side == SIDE.RIGHT:
		color_rect_red.position = Vector2(9, -5)
		color_rect_red.rotation_degrees = 90
		color_rect_black.position = Vector2(6, -8)
		color_rect_black.rotation_degrees = 90
		collision_base.position = Vector2(3, 0)
		collision_base.rotation_degrees = 90
		collision_button.position = Vector2(7.5, 0)
		collision_button.rotation_degrees = 90
	
	mouse_area.rotation = collision_base.rotation
	mouse_area.position = collision_button.position - collision_base.position

func _snap_to_grid() -> void:
	position.x = round(position.x / 8) * 8
	position.y = round(position.y / 8) * 8

func _on_button_rotate_pressed() -> void:
	if side == SIDE.UP:
		side = SIDE.RIGHT
	elif side == SIDE.RIGHT:
		side = SIDE.DOWN
	elif side == SIDE.DOWN:
		side = SIDE.LEFT
	elif side == SIDE.LEFT:
		side = SIDE.UP
	_update_area()
	_snap_to_grid()

func _on_button_door_connector_pressed() -> void:
	button_door_connector_pressed.emit()

func _on_mouse_entered() -> void:
	mouse_captured = true

func _on_mouse_exited() -> void:
	mouse_captured = false

func connect_creator_buttons() -> void:
	if not mouse_area.mouse_entered.is_connected(_on_mouse_entered):
		mouse_area.mouse_entered.connect(_on_mouse_entered)
	if not mouse_area.mouse_exited.is_connected(_on_mouse_exited):
		mouse_area.mouse_exited.connect(_on_mouse_exited)
	if not button_rotate.pressed.is_connected(_on_button_rotate_pressed):
		button_rotate.pressed.connect(_on_button_rotate_pressed)
	if not button_door_connector.pressed.is_connected(_on_button_door_connector_pressed):
		button_door_connector.pressed.connect(_on_button_door_connector_pressed)
	if not button_rotate_2.pressed.is_connected(_on_button_rotate_pressed):
		button_rotate_2.pressed.connect(_on_button_rotate_pressed)
	if not button_door_connector_2.pressed.is_connected(_on_button_door_connector_pressed):
		button_door_connector_2.pressed.connect(_on_button_door_connector_pressed)
