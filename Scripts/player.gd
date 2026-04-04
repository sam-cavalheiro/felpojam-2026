extends CharacterBody3D
class_name Player


@export var speed: float = 5.0
#@export var jump_velocity :float = 4.5
@export_file("*.tscn") var stamp_3d_base_file: String

@onready var animated_sprite: = $AnimatedSprite3D

var stamp_3d_base_loaded
var close_law_trigger: LawTrigger
var close_tv_trigger: TVEventTrigger


func _ready() -> void:
	LawsManager.on_approve_law.connect(on_approve_law)
	stamp_3d_base_loaded = load(stamp_3d_base_file)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if close_law_trigger:
			close_law_trigger.interact()
		elif close_tv_trigger:
			close_tv_trigger.interact()
		elif StampsManager.current_equip_index >= 0:
			# BUG: Está invertido
			# TODO: Colocar condicional em uma linha
			var mark_from_pos: Vector3
			if $AnimatedSprite3D.flip_h:
				mark_from_pos = $RightStampPoint.global_position
			else:
				mark_from_pos = $LeftStampPoint.global_position
			
			var mark_to_pos: = mark_from_pos
			mark_to_pos.y -= 100
			
			var space_state = get_world_3d().direct_space_state
			var query = PhysicsRayQueryParameters3D.create(mark_from_pos, mark_to_pos)
			var result = space_state.intersect_ray(query)
			var stamp_inst: Sprite3D = stamp_3d_base_loaded.instantiate()
			$"..".add_child(stamp_inst)
			stamp_inst.texture = StampsManager.current_stamp_texture
			stamp_inst.global_position = result.position + Vector3(0, 0.05, 0)
			stamp_inst.look_at(result.position + result.normal)
			stamp_inst.rotate_y(deg_to_rad(90))
			
			AudioManager.get_node("Audios/StampSE").position = get_viewport().get_camera_3d().unproject_position(global_position)
			AudioManager.get_node("Audios/StampSE").play()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		animated_sprite.play("run")
		if direction.x:
			animated_sprite.flip_h = direction.x < 0
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		animated_sprite.play("idle")
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

func on_approve_law(law_id: int) -> void:
	if close_law_trigger && close_law_trigger.law_id == law_id:
		close_law_trigger = null
