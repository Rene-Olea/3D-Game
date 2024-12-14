extends CharacterBody3D

enum State {
	IDLE,
	CHASE,
	ATTACK
}

@export var movement_speed: float = 4.0
@export var detection_radius: float = 5.0
@export var attack_radius: float = 2.0
@export var attack_cooldown: float = 1.5
@export var damage: float = 20.0
@export var attack_hitbox: Area3D

# Sound related exports
@export var footstep_player: AudioStreamPlayer3D
@export var effect_player: AudioStreamPlayer3D
@export var run_sound: AudioStream
@export var attack_sound: AudioStream

# Node references
@export var animation_player: AnimationPlayer
@export var model: Node3D

var current_state: State = State.IDLE
var player: Node3D = null
var can_attack: bool = true
var attack_timer: Timer

func _ready():
	# Setup attack timer
	attack_timer = Timer.new()
	attack_timer.one_shot = true
	attack_timer.wait_time = attack_cooldown
	add_child(attack_timer)
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	
	player = get_tree().get_first_node_in_group("player")
	
	# Setup attack hitbox
	if attack_hitbox:
		attack_hitbox.monitoring = false
		attack_hitbox.body_entered.connect(_on_attack_hitbox_body_entered)
	
	# Start idle animation
	if animation_player:
		animation_player.play("idle")

func _physics_process(delta):
	match current_state:
		State.IDLE:
			handle_idle_state()
		State.CHASE:
			handle_chase_state(delta)
		State.ATTACK:
			handle_attack_state()
	
	# Apply gravity
	if not is_on_floor():
		velocity.y -= 9.8 * delta
	
	move_and_slide()

func handle_idle_state():
	if player == null:
		return
	
	# Stop running sound if it's playing
	if footstep_player and footstep_player.playing:
		footstep_player.stop()
		
	var distance = global_position.distance_to(player.global_position)
	if distance < detection_radius:
		current_state = State.CHASE
		if animation_player:
			animation_player.play("run")
			# Start running sound when transitioning to chase
			if footstep_player and run_sound:
				footstep_player.stream = run_sound
				footstep_player.play()

func handle_chase_state(delta):
	if player == null:
		return
		
	var distance = global_position.distance_to(player.global_position)
	
	if distance > detection_radius:
		current_state = State.IDLE
		velocity.x = 0
		velocity.z = 0
		if animation_player:
			animation_player.play("idle")
			# Stop running sound
			if footstep_player and footstep_player.playing:
				footstep_player.stop()
		return
	
	if distance < attack_radius and can_attack:
		current_state = State.ATTACK
		# Stop running sound when attacking
		if footstep_player and footstep_player.playing:
			footstep_player.stop()
		return
	
	# Make sure running sound is playing while chasing
	if footstep_player and run_sound and !footstep_player.playing:
		footstep_player.stream = run_sound
		footstep_player.play()
	
	# Move towards player
	var direction = (player.global_position - global_position).normalized()
	direction.y = 0
	
	velocity.x = direction.x * movement_speed
	velocity.z = direction.z * movement_speed
	
	look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z))
	rotate_y(PI)

func handle_attack_state():
	if not can_attack:
		current_state = State.CHASE
		return
		
	perform_attack()
	can_attack = false
	attack_timer.start()
	current_state = State.CHASE

func perform_attack():
	if animation_player:
		animation_player.play("attack")
		# Play attack sound at start of attack
		if effect_player and attack_sound:
			effect_player.stream = attack_sound
			effect_player.play()
			
		if attack_hitbox:
			attack_hitbox.monitoring = true
			await get_tree().create_timer(0.3).timeout
			attack_hitbox.monitoring = false
		
		await animation_player.animation_finished
		if current_state == State.CHASE:
			animation_player.play("run")
			# Resume running sound after attack
			if footstep_player and run_sound:
				footstep_player.stream = run_sound
				footstep_player.play()

func _on_attack_timer_timeout():
	can_attack = true

func _on_attack_hitbox_body_entered(body: Node3D):
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(damage)
