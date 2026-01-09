class_name State_Falling extends State

@onready var idle: State_Idle = $"../Idle"
@onready var jump: State_Jump = $"../Jump"
@onready var get_up: State_GetUp = $"../GetUp"

# Called when the player initializes this State
func init() -> void:
	pass

# Called when the player enters this State
func enter() -> void:
	if player.player_active:
		player.update_animation("idle_stand")
	else:
		player.update_animation("idle_sit")

# Called when the player exits this State
func exit() -> void:
	pass

# Called during the _process update in this State
func process(_delta : float) -> State:
	return null

# Called during the _physics_process update in this State
func physics(delta : float) -> State:
	if player.is_on_floor() and player.contacted_floor:
		player.linear_velocity.y = 0
		return idle
	if player.contacted_floor and !player.between_max_rotation and player.horizontal_direction != 0:
		return get_up
	
	var v : float = player.linear_velocity.x
	
	if sign(v) != 0 and sign(player.horizontal_direction) != sign(v):
		v = move_toward(v, 0, player.air_friction * delta)
	else:
		v += player.move_speed * player.horizontal_direction * delta
		v = clamp(v, -player.max_move_speed, player.max_move_speed)
	
	player.linear_velocity.x = v
	
	if player.horizontal_direction < 0:
		player.player_sprite.scale.x = -1
	else:
		player.player_sprite.scale.x = 1
	
	return null

# Called for input events in this State
func handle_input(_event : InputEvent) -> State:
	return null
