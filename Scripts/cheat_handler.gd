extends Node

const SCENES_PATH: = "res://Nodes/Scenes/"


func _ready() -> void:
	if !OS.is_debug_build():
		queue_free()
		return
	
	$AcceptDialog.popup_centered()
	
	for dir_file in DirAccess.get_files_at(SCENES_PATH):
		if dir_file.ends_with(".tscn"):
			$PopupMenu.add_item(dir_file)

func _input(event: InputEvent) -> void:
	if event is InputEventKey && event.pressed && event.keycode == KEY_F12:
		$PopupMenu.popup_centered()


func _on_popup_menu_id_pressed(id: int) -> void:
	var menu_item_string: String = $PopupMenu.get_item_text($PopupMenu.get_item_index(id))
	get_tree().change_scene_to_file(SCENES_PATH + menu_item_string)
