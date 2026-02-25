extends Node3D


@export var follow_object :Node3D
@export var follow_speed :float = 1.0
@export var max_follow_distance :float = 3.0

@export var enable_min_x_boundaries := false
@export var min_x_boundaries :float = 0.0
@export var enable_max_x_boundaries := false
@export var max_x_boundaries :float = 0.0
@export var enable_min_z_boundaries := false
@export var min_z_boundaries :float = 0.0
@export var enable_max_z_boundaries := false
@export var max_z_boundaries :float = 0.0

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
	
	if enable_min_x_boundaries:
		global_position.x = max(global_position.x, min_x_boundaries)
	if enable_max_x_boundaries:
		global_position.x = min(global_position.x, max_x_boundaries)
	if enable_min_z_boundaries:
		global_position.z = max(global_position.z, min_z_boundaries)
	if enable_max_z_boundaries:
		global_position.z = min(global_position.z, max_z_boundaries)
