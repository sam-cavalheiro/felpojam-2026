extends Control
class_name LawHUD


@export var law_text_textures: Array[Texture2D]

var current_law: int
var is_safe_waiting: bool


func _ready() -> void:
	LawsManager.law_hud = self

func _process(delta: float) -> void:
	if !is_visible_in_tree() || is_safe_waiting:
		return
	
	if Input.is_action_just_pressed("interact"):
		if StampsManager.stamper_cursor_hud\
						.stamp_cursor_click_area\
						.get_global_rect()\
						.intersects($StampClickArea.get_global_rect()) \
		  && StampsManager.stamper_cursor_hud.stamp_mark_at_cursor_with_current():
			StampsManager.stamper_cursor_hud.disabled_interaction = true
			LawsManager.approve_law(current_law)
			await safe_wait(1.0)
			get_tree().paused = false
			hide()
			StampsManager.stamper_cursor_hud.hide()

func show_law(law_id: int) -> void:
	show()
	current_law = law_id
	$LawText_Texture.texture = law_text_textures[law_id]
	get_tree().paused = true
	StampsManager.stamper_cursor_hud.setup_and_show([$Quit_Button] as Array[BaseButton])

func safe_wait(seconds: float) -> void:
	is_safe_waiting = true
	await get_tree().create_timer(seconds).timeout
	is_safe_waiting = false


func _on_quit_button_pressed() -> void:
	if is_safe_waiting:
		return
	
	await safe_wait(0.1)
	get_tree().paused = false
	hide()
	StampsManager.stamper_cursor_hud.hide()
