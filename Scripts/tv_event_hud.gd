extends Control
class_name TVEventHUD


@onready var tv_display: TextureRect = $TextureRect

var is_safe_waiting: bool
var from_trigger: TVEventTrigger


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LawsManager.on_approve_law.connect(on_approve_law)
	TVEventManager.tv_event_hud = self

func _process(delta: float) -> void:
	if is_safe_waiting || !is_visible_in_tree():
		return
	
	if Input.is_action_just_pressed("interact") && \
		StampsManager.current_equip_index >= 0 && \
		StampsManager.stamper_cursor_hud.stamp_cursor_click_area\
					.get_global_rect()\
					.intersects(tv_display.get_global_rect()):
		var stamp_id: = StampsManager.collected_stamps[StampsManager.current_equip_index]
		var stamp_position: = StampsManager.stamper_cursor_hud.get_cursor_mark_position()
		stamp_position.x = clamp(stamp_position.x,
								 tv_display.global_position.x,
								 tv_display.global_position.x + tv_display.size.x - StampsManager.stamper_cursor_hud.stamp_mark_size.x)
		stamp_position.y = clamp(stamp_position.y,
								 tv_display.global_position.y,
								 tv_display.global_position.y + tv_display.size.y - StampsManager.stamper_cursor_hud.stamp_mark_size.y)
		if StampsManager.stamper_cursor_hud.stamp_mark(stamp_id, stamp_position):
			from_trigger.marked_stamps.append(StampPosition.new(stamp_id, stamp_position))

func show_current_news(from_trigger: TVEventTrigger) -> void:
	self.from_trigger = from_trigger
	show()
	StampsManager.stamper_cursor_hud.setup_and_show([$TextureRect/Close_Button] as Array[BaseButton], from_trigger.marked_stamps)
	get_tree().paused = true

func safe_wait(seconds: float) -> void:
	is_safe_waiting = true
	await get_tree().create_timer(seconds).timeout
	is_safe_waiting = false

func close() -> void:
	StampsManager.stamper_cursor_hud.disabled_interaction = true
	await safe_wait(0.1)
	hide()
	StampsManager.stamper_cursor_hud.hide()
	get_tree().paused = false

func on_approve_law(law_id: int) -> void:
	$TextureRect.texture = TVEventManager.current_tv_texture

func _on_close_button_pressed() -> void:
	if is_safe_waiting:
		return
	
	close()
