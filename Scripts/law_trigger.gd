extends Area3D
class_name LawTrigger


@export var law_id: int = -1


func _ready() -> void:
	LawsManager.on_approve_law.connect(on_approve_law)
	
	if law_id < 0:
		law_id = randi_range(LawsManager.min_law_id, LawsManager.max_law_id)

func interact() -> void:
	LawsManager.ask_law(law_id)


func on_approve_law(law_id: int) -> void:
	if self.law_id == law_id:
		LawsManager.on_approve_law.disconnect(on_approve_law)
		queue_free()

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body.close_law_trigger = self

func _on_body_exited(body: Node3D) -> void:
	if body is Player && body.close_law_trigger == self:
		body.close_law_trigger = null
