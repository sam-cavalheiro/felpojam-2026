extends Control

const FADEOUT_DURATION: float = 10.0

@onready var fade_count = FADEOUT_DURATION

var is_fading: bool


func _process(delta: float) -> void:
	if !is_fading:
		return
	
	fade_count -= delta
	modulate.a = fade_count / FADEOUT_DURATION
	if fade_count <= 0:
		queue_free()


func _on_wait_timer_timeout() -> void:
	is_fading = true

func _on_tools_button_pressed() -> void:
	$"../../..".show_or_hide_help_window()

func _on_close_button_pressed() -> void:
	queue_free()
