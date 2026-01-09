class_name State_Walk extends State

@onready var idle: State = $"../Idle"
@onready var jump: State_Jump = $"../Jump"
@onready var get_up: State_GetUp = $"../GetUp"
@onready var falling: State_Falling = $"../Falling"

# Called when the player initializes this State
func init() -> void:
	pass

# Called when the player enters this State
func enter() -> void:
	player.update_animation("walk")
	player.linear_velocity.x += player.horizontal_direction * player.move_speed / 10

# Called when the player exits this State
func exit() -> void:
	pass

# Called during the _process update in this State
func process(delta : float) -> State:
	if player.horizontal_direction == 0:
		return idle
	if not player.between_max_rotation:
		return get_up
	if not player.is_on_floor():
		return falling
	
	var v : float = player.linear_velocity.x
	
	if sign(v) != 0 and sign(player.horizontal_direction) != sign(v):
		v = move_toward(v, 0, player.ground_friction * player.reverse_mult * delta)
	else:
		v += player.move_speed * player.horizontal_direction * delta
		v = clamp(v, -player.max_move_speed, player.max_move_speed)
	
	var bmr := player.between_max_rotation
	var sr : int = sign(player.rotation)
	var shd : int = sign(player.horizontal_direction)
	
	if bmr and sr == shd:
		player.linear_velocity.x = v
	
	if player.horizontal_direction < 0:
		player.player_sprite.scale.x = -1
	else:
		player.player_sprite.scale.x = 1
	
	player.update_animation("walk")
	
	return null

# Called during the _physics_process update in this State
func physics(_delta : float) -> State:
	var max_tilt := deg_to_rad(player.max_tilt_deg)
	
	if player.is_on_floor() and player.is_pushing() and player.linear_velocity.y < 0.0:
		player.linear_velocity.y = 0.0
	
	if player.rotation < max_tilt and player.rotation > -max_tilt:
		player.between_max_rotation = true
	
	if player.between_max_rotation:
		if player.players_on_top > 0:
			max_tilt = deg_to_rad(1)
			if player.rotation > max_tilt:
				player.rotation = lerp(player.rotation, max_tilt, player.tilt_correction_strength)
			elif player.rotation < -max_tilt:
				player.rotation = lerp(player.rotation, -max_tilt, player.tilt_correction_strength)
		elif player.rotation > max_tilt:
			player.rotation = lerp(player.rotation, max_tilt, player.tilt_correction_strength)
		elif player.rotation < -max_tilt:
			player.rotation = lerp(player.rotation, -max_tilt, player.tilt_correction_strength)
		player.angular_velocity = 0.0
	
	return null

# Called for input events in this State
func handle_input(event : InputEvent) -> State:
	if player.player_active and event.is_action_pressed("jump"):
		jump.jumping = true
		return jump
	return null
