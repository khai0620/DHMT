extends Node

var main_scene_path: String = "res://sences/main_scene.tscn"

func load_main_scene_container() -> void:
	var node: Node = load(main_scene_path).instantiate()
	
	if node != null:
		get_tree().root.add_child(node)
