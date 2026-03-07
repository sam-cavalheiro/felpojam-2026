extends Area3D
class_name TeleporTrigger

@export_file("*.tscn") var map

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_body_entered)

func on_body_entered(body: Node3D):
	if body is Player:
		get_tree().change_scene_to_file(map)
