extends Area3D
class_name Checkpoint

signal checkpoint_reached(position: Vector3)

@export var checkpoint_id: int = 0

func _ready():
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":
		checkpoint_reached.emit(global_position)
