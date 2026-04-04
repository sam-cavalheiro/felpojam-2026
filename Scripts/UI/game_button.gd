extends Button


@export var start_focused: bool = false
## Não realizar ações de foco até que o foco tenha ocorrido uma vez.
## Recomendado caso esse botão já inicie focado.
@export var focus_flag_toggle: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if start_focused:
		grab_focus()


func _on_mouse_entered() -> void:
	grab_focus()

func _on_focus_entered() -> void:
	if focus_flag_toggle:
		focus_flag_toggle = false
	else:
		AudioManager.get_node("Audios/Interface/CursorMoveSE").play()

func _on_pressed() -> void:
	AudioManager.get_node("Audios/Interface/CursorConfirmSE").play()
