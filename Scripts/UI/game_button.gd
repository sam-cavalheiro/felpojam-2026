extends Button


@export var start_focused: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if start_focused:
		grab_focus()


func _on_mouse_entered() -> void:
	grab_focus()
