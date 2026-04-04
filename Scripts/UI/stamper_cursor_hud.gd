extends Control
class_name StamperCursorHUD


@export_file("*.tscn") var stamp_mark_file: String
@export var cursor_move_speed: float = 2.0
@export var stamp_mark_size: Vector2 = Vector2(10.0, 10.0)

@onready var stamp_cursor: TextureRect = $StampCursor
@onready var stamp_cursor_click_area: Control = $StampCursor/ClickArea

var disabled_interaction: bool
var is_cursor_near_any_button: bool
var interactible_buttons: Array[BaseButton]
var pinned_interactible_buttons: Array[BaseButton]
var stamp_mark_loaded


func _ready() -> void:
	StampsManager.stamper_cursor_hud = self
	stamp_mark_loaded = load(stamp_mark_file)

func setup_and_show(interactible_buttons: Array[BaseButton], stamp_marks: Array[StampPosition] = [], disabled_interaction: bool = false) -> void:
	self.interactible_buttons = interactible_buttons
	self.disabled_interaction = disabled_interaction
	
	# TODO: Otimizar
	for child in $StampMark_Holder.get_children():
		child.queue_free()
	for stamp_position in stamp_marks:
		stamp_mark(stamp_position.stamp_id, stamp_position.stamp_position, false)
	
	show()

func _process(delta: float) -> void:
	if !is_visible_in_tree():
		return
	
	var input_dir: = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if input_dir:
		stamp_cursor.global_position += input_dir * cursor_move_speed
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if disabled_interaction:
		return
	
	is_cursor_near_any_button = false
	
	if !button_process(interactible_buttons):
		button_process(pinned_interactible_buttons)

func _input(event: InputEvent) -> void:
	if !is_visible_in_tree():
		return
	
	if event is InputEventMouseMotion:
		stamp_cursor.global_position = event.position - stamp_cursor.pivot_offset
		if !is_cursor_near_any_button:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

# Retorna true se algum botão foi intersectado
func button_process(buttons: Array[BaseButton]) -> bool:
	for button in buttons:
		if stamp_cursor_click_area.get_global_rect().intersects(button.get_global_rect()):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			is_cursor_near_any_button = true
			
			if Input.is_action_just_pressed("interact"):
				if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
					if !button.is_hovered():
						button.grab_focus(true)
						button.pressed.emit()
				else:
					button.grab_focus(true)
					button.pressed.emit()
			return true
	return false

# Retorna true se conseguiu carimbar
func stamp_mark(stamp_id: int, stamp_position: Vector2, play_se: = true) -> bool:
	if stamp_id < 0:
		return false
	
	var mark_inst: TextureRect = stamp_mark_loaded.instantiate()
	$StampMark_Holder.add_child(mark_inst)
	mark_inst.texture = StampsManager.stamp_marks[stamp_id]
	mark_inst.global_position = stamp_position
	
	if play_se:
		AudioManager.get_node("Audios/StampSE").position = stamp_position
		AudioManager.get_node("Audios/StampSE").play()
	
	return true

func stamp_mark_at_cursor_with_current(play_se: = true) -> bool:
	if StampsManager.current_equip_index < 0:
		return false
	
	return stamp_mark(StampsManager.collected_stamps[StampsManager.current_equip_index],
					 get_cursor_mark_position(),
					 play_se)

func get_cursor_mark_position() -> Vector2:
	return stamp_cursor.global_position + stamp_cursor.pivot_offset - (stamp_mark_size * 0.5)


func _on_hidden() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
