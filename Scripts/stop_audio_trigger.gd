extends InGameTrigger
class_name StopAudioTrigger

@export var stop_bgm: bool = false
@export var stop_bgs: bool = false

func on_trigger() -> void:
	if stop_bgm:
		AudioManager.get_node("BGMPlayer").stop()
	if stop_bgs:
		AudioManager.get_node("BGSPlayer").stop()
