extends Control
class_name DebugSceneChangerWindow


const SCENES_PATH: = "res://Nodes/Scenes/"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for dir_file in ResourceLoader.list_directory(SCENES_PATH):
		if dir_file.ends_with(".tscn"):
			$Scenes_ItemList.add_item(dir_file)

func go_to_scene_on_list(index: int) -> void:
	var item_list_string: String = $Scenes_ItemList.get_item_text(index)
	SceneManager.change_scene_to_file(SCENES_PATH + item_list_string)
	hide()

func _on_scenes_item_list_item_activated(index: int) -> void:
	go_to_scene_on_list(index)

func _on_ok_button_pressed() -> void:
	var selected_items: PackedInt32Array = $Scenes_ItemList.get_selected_items()
	if selected_items.size() > 0:
		go_to_scene_on_list(selected_items[0])

func _on_cancel_button_pressed() -> void:
	hide()

func _on_close_button_pressed() -> void:
	hide()
