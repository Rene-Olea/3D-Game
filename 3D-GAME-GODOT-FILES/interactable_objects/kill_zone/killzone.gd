extends Area3D

var current_spawn_position = Vector3(0, 2, 0)
@export var splash_sound: AudioStreamPlayer3D

func _ready():
	self.body_entered.connect(_on_body_entered)
	for checkpoint in get_tree().get_nodes_in_group("checkpoints"):
		checkpoint.checkpoint_reached.connect(_on_checkpoint_reached)

func _on_body_entered(body):
	#print("Body entered: ", body.name)
	if body.name == "Player" or body.name.begins_with("enemy"):
		# Play splash sound if the body is the player or an enemy
		if splash_sound:
			#print("Playing splash sound for: ", body.name)
			splash_sound.play()
		
		# Reset player position if it's the player
		if body.name == "Player":
			body.global_position = current_spawn_position
			body.velocity = Vector3.ZERO

func _on_checkpoint_reached(pos: Vector3):
	current_spawn_position = pos
	current_spawn_position.y += 2.0
