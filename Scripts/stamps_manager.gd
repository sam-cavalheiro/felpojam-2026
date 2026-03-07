extends Node


@export var stamp_marks: Array[Texture2D]


var stamps_hud: StampsHUD
var stamper_cursor_hud: StamperCursorHUD
var collected_stamps: Array[int]
var current_equip_index: int = -1
var current_stamp_texture: Texture2D # TODO: Verificar se ainda faz sentido tal variável


func add_stamp(stamp_id) -> void:
	collected_stamps.append(stamp_id)
	stamps_hud.add_stamp(stamp_id)
	
	if collected_stamps.size() == 1:
		switch_stamp(0)

func switch_next_stamp() -> void:
	if collected_stamps.size() > 0:
		switch_stamp((current_equip_index + 1) % collected_stamps.size())

func switch_previous_stamp() -> void:
	if collected_stamps.size() > 0:
		switch_stamp((current_equip_index - 1 + collected_stamps.size()) % collected_stamps.size())

func switch_stamp(equip_index: int) -> void:
	if equip_index < collected_stamps.size():
		current_equip_index = equip_index
		current_stamp_texture = stamp_marks[collected_stamps[equip_index]]
		stamps_hud.equip_stamp(equip_index)
		print("current_equip_index = " + str(current_equip_index))
