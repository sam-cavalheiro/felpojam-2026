extends Control


func _on_back_button_pressed() -> void:
	hide()

func _on_visibility_changed() -> void:
	if is_visible_in_tree():
		$Holder_TextureRect/Credits_Holder/Back_Button.grab_focus()
	else:
		$"../VBoxContainer/Credits_Button".grab_focus()
