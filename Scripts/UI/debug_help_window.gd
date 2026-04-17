extends Panel
class_name DebugHelpWindow


func _on_visibility_changed() -> void:
	if is_visible_in_tree() && $Ok_Button.is_inside_tree():
		$Ok_Button.grab_focus(true)

func _on_ok_button_pressed() -> void:
	hide()

func _on_close_button_pressed() -> void:
	hide()
