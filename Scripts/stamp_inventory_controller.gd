extends Node


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("switch_next_stamp"):
		StampsManager.switch_next_stamp()
	elif Input.is_action_just_pressed("switch_previous_stamp"):
		StampsManager.switch_previous_stamp()
	else:
		for i in range(1, 9):
			if Input.is_action_just_pressed("switch_stamp_" + str(i)):
				StampsManager.switch_stamp(i - 1)
		if Input.is_action_just_pressed("switch_stamp_0"):
			StampsManager.switch_stamp(9)
