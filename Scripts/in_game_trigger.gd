@abstract
extends Node
class_name InGameTrigger


enum TriggerType { TRIGGER, ON_READY, ON_AREA_ENTER }

@export var trigger_type: = TriggerType.TRIGGER
@export var area_enter_trigger: Area3D
@export var destroy_after_trigger: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match trigger_type:
		TriggerType.ON_READY:
			trigger()
		TriggerType.ON_AREA_ENTER:
			if area_enter_trigger:
				area_enter_trigger.area_entered.connect(trigger)

func trigger() -> void:
	on_trigger()
	if destroy_after_trigger:
		queue_free()

@abstract func on_trigger() -> void
