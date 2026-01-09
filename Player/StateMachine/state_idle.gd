class_name State_Idle extends State

@onready var walk: State = $"../Walk"
@onready var jump: State_Jump = $"../Jump"
@onready var get_up: State_GetUp = $"../GetUp"
@onready var falling: State_Falling = $"../Falling"

var idle_gf : float

# Called when the player initializes this State
func init() -> void:
	idle_gf = player.ground_friction
	pass

# Called when the player enters this State
func enter() -> void:
	if player.standing:
		player.update_animation("idle_stand")
	else:
		player.update_animation("idle_sit")

# Called when the player exits this State
func exit() -> void:
	pass

# Called during the _process update in this State
func process(_delta : float) -> State:
	if player.player_active and player.horizontal_direction != 0:
		return walk
	if not player.is_on_floor():
		return falling
	
	return null

# Called during the _physics_process update in this State
func physics(_delta : float) -> State:
	if player.player_active:
		return walk.physics(_delta)
	return null

# Called for input events in this State
func handle_input(event : InputEvent) -> State:
	if player.player_active and !player.between_max_rotation:
		if event.is_action_pressed("move_left") or event.is_action_pressed("move_right"):
			return get_up
	if player.player_active and event.is_action_pressed("jump"):
		jump.jumping = true
		return jump
	return null
