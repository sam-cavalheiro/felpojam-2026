extends Panel
class_name DebugHelpWindow


func _on_visibility_changed() -> void:
	if visible:
		$Ok_Button.grab_focus(true)

func _on_ok_button_pressed() -> void:
	hide()

func _on_close_button_pressed() -> void:
	hide()
