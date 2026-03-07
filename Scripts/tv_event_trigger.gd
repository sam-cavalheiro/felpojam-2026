extends Area3D
class_name TVEventTrigger


@export var tv_screen :Node3D

var marked_stamps: Array[StampPosition]


func _ready() -> void:
	LawsManager.on_approve_law.connect(on_approve_law)
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	set_tv_screen_texture(TVEventManager.tv_no_news_texture)

func interact() -> void:
	TVEventManager.tv_event_hud.show_current_news(self)

func set_tv_screen_texture(texture: Texture2D):
	if tv_screen is Sprite3D:
		tv_screen.texture = texture
	elif tv_screen is MeshInstance3D:
		var material: = StandardMaterial3D.new()
		material.albedo_texture = texture
		tv_screen.material_override = material

func on_approve_law(law_id: int) -> void:
	set_tv_screen_texture(TVEventManager.current_tv_texture)

func on_body_entered(body: Node3D) -> void:
	if body is Player:
		body.close_tv_trigger = self

func on_body_exited(body: Node3D) -> void:
	if body is Player && body.close_tv_trigger == self:
		body.close_tv_trigger = null
