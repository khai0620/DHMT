class_name CropsCursorComponent
extends Node
 
@export var tilled_soil_tilemap_layer: TileMapLayer

@onready var player: Player = null

func _ready() -> void:
	player = get_player()
	if player == null:
		push_warning("CropsCursorComponent: player node not found in the scene tree.")

func get_player() -> Player:
	var found_player = get_tree().get_first_node_in_group("player")
	if found_player != null:
		return found_player
	var current_scene = get_tree().get_current_scene()
	if current_scene != null:
		return current_scene.find_child("Player", true, false) as Player
	return null

var corn_plant_scene = preload("res://sences/objects/corn.tscn")
var tomato_plant_scene = preload("res://sences/objects/tomato.tscn")

var mouse_position: Vector2
var cell_position: Vector2i
var cell_source_id: int
var local_cell_position: Vector2
var distance: float

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("remove_dirt"):
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_cell_under_mouse()
			remove_crop()
	elif event.is_action_pressed("hit"):
		if ToolManager.selected_tool == DataTypes.Tools.PlantCorn or ToolManager.selected_tool == DataTypes.Tools.PlantTomato:
			get_cell_under_mouse()
			add_crop()


func get_cell_under_mouse() -> void:
	if player == null:
		player = get_player()
	mouse_position = tilled_soil_tilemap_layer.get_local_mouse_position()
	cell_position = tilled_soil_tilemap_layer.local_to_map(mouse_position)
	cell_source_id = tilled_soil_tilemap_layer.get_cell_source_id(cell_position)
	local_cell_position = tilled_soil_tilemap_layer.map_to_local(cell_position)
	if player != null:
		distance = player.global_position.distance_to(local_cell_position)
	else:
		distance = INF

func add_crop() -> void:
	if distance < 20.0:
		if ToolManager.selected_tool == DataTypes.Tools.PlantCorn:
			var corn_instance = corn_plant_scene.instantiate() as Node
			corn_instance.global_position = local_cell_position
			get_parent().find_child("CropFields").add_child(corn_instance)
			
		if ToolManager.selected_tool == DataTypes.Tools.PlantTomato:
			var tomato_instance = tomato_plant_scene.instantiate() as Node
			tomato_instance.global_position = local_cell_position
			get_parent().find_child("CropFields").add_child(tomato_instance)
			
			
func remove_crop() -> void:
	if distance < 20.0:
		var crop_nodes = get_parent().find_child("CropFields").get_children()
		
		for node: Node2D in crop_nodes:
			if node.global_position == local_cell_position:
				node.queue_free()
