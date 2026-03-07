extends Control
class_name StampsHUD


@export_file("*.tscn") var stamp_button_file: String

var stamp_button_loaded
var current_equip_index: int
var inventory_buttons: Array[TextureButton] # TODO: Checar se a existência dessa variável faz sentido


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	StampsManager.stamps_hud = self
	stamp_button_loaded = load(stamp_button_file)

func add_stamp(stamp_id: int) -> void:
	var stamp_button_inst: TextureButton = stamp_button_loaded.instantiate()
	$StampInventory_HBox.add_child(stamp_button_inst)
	inventory_buttons.append(stamp_button_inst)
	StampsManager.stamper_cursor_hud.pinned_interactible_buttons.append(stamp_button_inst)
	stamp_button_inst.get_node("StampIcon").texture = StampsManager.stamp_marks[stamp_id]
	var index_at_collection: = $StampInventory_HBox.get_child_count() - 1
	stamp_button_inst.pressed.connect(func(): StampsManager.switch_stamp(index_at_collection))
	stamp_button_inst.custom_minimum_size = Vector2($StampInventory_HBox.size.y,
													$StampInventory_HBox.size.y)

func equip_stamp(equip_index: int) -> void:
	# Caso necessário, faça uma condição para verificar se é diferente
	if current_equip_index >= 0:
		inventory_buttons[current_equip_index].button_pressed = false
	inventory_buttons[equip_index].button_pressed = true
	current_equip_index = equip_index

func _on_item_rect_changed() -> void:
	for inventory_button in inventory_buttons:
		inventory_button.custom_minimum_size = Vector2(
													$StampInventory_HBox.size.y,
													$StampInventory_HBox.size.y)
