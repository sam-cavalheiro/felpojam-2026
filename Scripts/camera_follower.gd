extends Node3D


@export var follow_object :Node3D
@export var follow_speed :float = 1.0
@export var max_follow_distance :float = 3.0
#@export var follow_acelleration :float = 0.5
#@export var follow_min_distance :float = 0.4
#@export var stop_follow_min_distance :float = 0.1

#var total_acceleration :float


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.x = move_toward(global_position.x, follow_object.global_position.x, follow_speed * delta)
	global_position.z = move_toward(global_position.z, follow_object.global_position.z, follow_speed * delta)
	global_position.x = clamp(global_position.x, follow_object.global_position.x - max_follow_distance, follow_object.global_position.x + max_follow_distance)
	global_position.z = clamp(global_position.z, follow_object.global_position.z - max_follow_distance, follow_object.global_position.z + max_follow_distance)
