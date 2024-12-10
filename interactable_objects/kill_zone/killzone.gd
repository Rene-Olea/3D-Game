extends Area3D

var respawn_position = Vector3(0, 2, 0) 

func _ready():
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player": 
		body.global_position = respawn_position
		body.velocity = Vector3.ZERO
