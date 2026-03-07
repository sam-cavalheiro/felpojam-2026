extends Node


@export var tv_news_textures: Array[Texture2D]
@export var tv_no_news_texture: Texture2D

var tv_event_hud: TVEventHUD
var current_tv_texture: Texture2D


func _ready() -> void:
	LawsManager.on_approve_law.connect(on_approve_law)


func on_approve_law(law_id: int) -> void:
	if tv_news_textures.size() - 1 >= law_id && tv_news_textures[law_id]:
		current_tv_texture = tv_news_textures[law_id]
	else:
		current_tv_texture = tv_no_news_texture
