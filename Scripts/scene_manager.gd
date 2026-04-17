extends Node

var scene_root: Node


func _ready() -> void:
	var root :Node = get_tree().get_root()
	scene_root = Node.new()
	scene_root.name = "Scene"
	root.call_deferred("add_child", scene_root)
	root.get_child(root.get_child_count() - 1).call_deferred("reparent", scene_root)

# TODO: Adicionar outras formas de trocar cenas conforme necessário

func change_scene_to_file(path: String) -> void:
	var load_scene = load(path)
	var new_scene: Node = load_scene.instantiate()
	scene_root.get_child(0).queue_free()
	scene_root.add_child(new_scene)
