extends Control


@export_file("*.tscn") var game_scene :String



func _on_play_button_pressed() -> void:
	SceneManager.change_scene_to_file(game_scene)

func _on_credits_button_pressed() -> void:
	$"Créditos".show()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
