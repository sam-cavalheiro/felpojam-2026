extends Area3D

@export var stamp_id: int


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		StampsManager.add_stamp(stamp_id)
		queue_free()
