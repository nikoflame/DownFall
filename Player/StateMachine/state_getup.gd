class_name State_GetUp extends State

@onready var idle: State = $"../Idle"
@onready var jump: State_Jump = $"../Jump"
@onready var walk: State_Walk = $"../Walk"

# Called when the player initializes this State
func init() -> void:
	pass

# Called when the player enters this State
func enter() -> void:
	player.update_animation("walk")

# Called when the player exits this State
func exit() -> void:
	pass

# Called during the _process update in this State
func process(_delta : float) -> State:
	if player.horizontal_direction == 0:
		return idle
	if player.between_max_rotation:
		return walk
	
	if player.horizontal_direction < 0:
		player.player_sprite.scale.x = -1
	else:
		player.player_sprite.scale.x = 1
	
	player.update_animation("walk")
	
	return null

# Called during the _physics_process update in this State
func physics(_delta : float) -> State:
	var max_tilt := deg_to_rad(player.max_tilt_deg)
	
	if player.rotation < max_tilt and player.rotation > -max_tilt:
		player.between_max_rotation = true
	
	if not player.between_max_rotation:
		for c in player.get_colliding_bodies():
			if c != self and c != null:
				if abs(c.global_position.direction_to(player.global_position).x) < 10:
					if sign(player.rotation) != sign(player.horizontal_direction):
						player.apply_torque_impulse(-player.rotation * player.getup_torque * 2 * _delta)
					else:
						player.apply_torque_impulse(player.rotation * player.getup_torque * 2 * _delta)
		if sign(player.rotation) != sign(player.horizontal_direction):
			player.apply_torque_impulse(-player.rotation * player.getup_torque * _delta)
		else:
			player.apply_torque_impulse(player.rotation * player.getup_torque * _delta)
	return null

# Called for input events in this State
func handle_input(event : InputEvent) -> State:
	if player.player_active and event.is_action_pressed("jump"):
		jump.jumping = true
		return jump
	return null
