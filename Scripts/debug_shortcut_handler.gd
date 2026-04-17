extends Node



func _ready() -> void:
	if !OS.is_debug_build():
		queue_free()
		return

func _shortcut_input(event: InputEvent) -> void:
	if event is InputEventKey && event.pressed:
		match event.keycode:
			KEY_F1:
				show_or_hide_help_window()
			KEY_F11:
				var debug_audio_player_window: DebugAudioPlayerWindow = get_node_or_null("CanvasLayer/UI/DebugAudioPlayerWindow")
				
				if debug_audio_player_window:
					debug_audio_player_window.visible = !debug_audio_player_window.visible
				else:
					var load_dapw = load("res://Nodes/UI/debug_audio_player_window.tscn")
					debug_audio_player_window = load_dapw.instantiate()
					$CanvasLayer/UI.add_child(debug_audio_player_window)
			KEY_F12:
				var debug_scene_changer_window: DebugSceneChangerWindow = get_node_or_null("CanvasLayer/UI/DebugSceneChangerWindow")
				
				if debug_scene_changer_window:
					debug_scene_changer_window.visible = !debug_scene_changer_window.visible
				else:
					var load_dscw = load("res://Nodes/UI/debug_scene_changer_window.tscn")
					debug_scene_changer_window = load_dscw.instantiate()
					$CanvasLayer/UI.add_child(debug_scene_changer_window)

func show_or_hide_help_window() -> void:
	var debug_help_window: DebugHelpWindow = get_node_or_null("CanvasLayer/UI/DebugHelpWindow")
	
	if debug_help_window:
		debug_help_window.visible = !debug_help_window.visible
	else:
		var load_dhw = load("res://Nodes/UI/debug_help_window.tscn")
		debug_help_window = load_dhw.instantiate()
		$CanvasLayer/UI.add_child(debug_help_window)
