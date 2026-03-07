extends Node


@export var min_law_id: int = 0
@export var max_law_id: int = 0

var law_hud: LawHUD

signal on_approve_law(law_id :int)


func ask_law(law_id: int) -> void:
	law_hud.show_law(law_id)

func approve_law(law_id: int) -> void:
	on_approve_law.emit(law_id)
