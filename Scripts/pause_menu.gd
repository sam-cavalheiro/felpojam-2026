extends Control

@export_file("*.tscn") var title_menu_scene :String

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = !get_tree().paused
		visible = !visible

func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	hide()

func _on_title_screen_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(title_menu_scene)
