class_name State extends Node

## Stores a reference to the player that this State belongs to
var player : Player = PlayerManager.player
static var state_machine : PlayerStateMachine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called when the player initializes this State
func init() -> void:
	pass

# Called when the player enters this State
func enter() -> void:
	pass

# Called when the player exits this State
func exit() -> void:
	pass

# Called during the _process update in this State
func process(_delta : float) -> State:
	return null

# Called during the _physics_process update in this State
func physics(_delta : float) -> State:
	return null

# Called for input events in this State
func handle_input(_event : InputEvent) -> State:
	return null

func _on_player_change() -> void:
	pass
