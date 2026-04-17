extends Control

@export_file("*.tscn") var title_menu_scene :String

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_visible_in_tree():
		if Input.is_action_just_pressed("pause") || \
			Input.is_action_just_pressed("ui_cancel"):
			get_tree().paused = false
			hide()
	elif Input.is_action_just_pressed("pause") && \
		!LawsManager.law_hud.visible && !TVEventManager.tv_event_hud.visible:
		get_tree().paused = true
		show()

func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	hide()

func _on_title_screen_button_pressed() -> void:
	get_tree().paused = false
	SceneManager.change_scene_to_file(title_menu_scene)
