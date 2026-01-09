class_name State_Jump extends State

@onready var walk: State = $"../Walk"
@onready var idle: State_Idle = $"../Idle"
@onready var get_up: State_GetUp = $"../GetUp"
@onready var falling: State_Falling = $"../Falling"

var jumping : bool = false
var start : bool = false
var last_rotation : float

# Called when the player initializes this State
func init() -> void:
	pass

# Called when the player enters this State
func enter() -> void:
	start = true
	last_rotation = player.rotation
	player.update_animation("jump")
	await player.animation_player.animation_finished
	start = false
	player.update_animation("idle_stand")
	player.feet_cast.enabled = false
	await get_tree().create_timer(0.1).timeout
	player.feet_cast.enabled = true

# Called when the player exits this State
func exit() -> void:
	pass

# Called during the _process update in this State
func process(_delta : float) -> State:
	return null

# Called during the _physics_process update in this State
func physics(delta : float) -> State:
	if start:
		player.rotation = last_rotation
		return null
	if player.is_on_floor() and not jumping and player.contacted_floor:
		player.linear_velocity.y = 0
		return idle
	
	var v : float = player.linear_velocity.x
	
	if sign(v) != 0 and sign(player.horizontal_direction) != sign(v):
		v = move_toward(v, 0, player.air_friction * delta)
	else:
		v += player.move_speed * player.horizontal_direction * delta
		v = clamp(v, -player.max_move_speed, player.max_move_speed)
	
	player.linear_velocity.x = v
	
	if player.horizontal_direction != 0:
		if sign(player.rotation) != sign(player.horizontal_direction):
			player.apply_torque_impulse(-player.rotation * (player.getup_torque / 2) * delta)
		else:
			player.apply_torque_impulse(player.rotation * (player.getup_torque / 2) * delta)
	
	if jumping:
		jumping = false
		player.linear_velocity.y = 0
		if player.between_max_jump_rotation:
			AudioManager.jump.pitch_scale = randf_range(0.95, 1.05)
			AudioManager.jump.play()
			if player.between_max_rotation:
				player.apply_impulse(Vector2(0, -player.jump_speed))
			else:
				player.apply_impulse(Vector2(player.rotation * player.jump_speed / 2, -player.jump_speed))
		
	if player.horizontal_direction < 0:
		player.player_sprite.scale.x = -1
	else:
		player.player_sprite.scale.x = 1
	
	return null

# Called for input events in this State
func handle_input(_event : InputEvent) -> State:
	return null
