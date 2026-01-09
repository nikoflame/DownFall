class_name PlayerStateMachine extends Node

var states : Array[State]
var prev_state : State
var current_state : State

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	change_state(current_state.process(delta))

func _physics_process(delta: float):
	change_state(current_state.physics(delta))

func _unhandled_input(event: InputEvent) -> void:
	if (
		event.is_action_pressed("jump")
		or event.is_action_pressed("move_left") 
		or event.is_action_pressed("move_right")
		):
		change_state(current_state.handle_input(event))

func initialize(player = Player) -> void:
	states = []
	
	for c in get_children():
		if c is State:
			states.append(c)
	
	if states.size() == 0:
		return
	
	for state in states:
		state.player = player
		state.state_machine = self
		state.init()
	
	change_state(states[0])
	process_mode = Node.PROCESS_MODE_INHERIT

func change_state(new_state : State) -> void:
	if new_state == null || new_state == current_state:
		return
	
	if current_state:
		current_state.exit()
	
	prev_state = current_state
	current_state = new_state
	current_state.enter()
