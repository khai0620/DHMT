class_name CropsCursorComponent
extends Node

@export var tilled_soil_tilemap_layer: TileMapLayer

@onready var player: Player = null

var corn_plant_scene = preload("res://sences/objects/corn.tscn")
var tomato_plant_scene = preload("res://sences/objects/tomato.tscn")

var mouse_position: Vector2
var cell_position: Vector2i
var cell_source_id: int
var local_cell_position: Vector2
var distance: float

func _ready() -> void:
	# Chờ 1 khung hình để đảm bảo Map đã load
	await get_tree().process_frame
	
	# TỰ ĐỘNG SỬA LỖI NULL: Nếu chưa kéo layer vào Inspector, code sẽ tự tìm
	if tilled_soil_tilemap_layer == null:
		tilled_soil_tilemap_layer = get_tree().current_scene.find_child("TilledSoil", true, false) as TileMapLayer
	
	player = get_player()

func get_player() -> Player:
	var found_player = get_tree().get_first_node_in_group("player")
	if found_player != null:
		return found_player
	var current_scene = get_tree().get_current_scene()
	if current_scene != null:
		return current_scene.find_child("Player", true, false) as Player
	return null

func _unhandled_input(event: InputEvent) -> void:
	# Tránh chạy code nếu layer bị null
	if tilled_soil_tilemap_layer == null: return

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
	
	# Sử dụng tọa độ toàn cầu để tính khoảng cách chính xác hơn
	mouse_position = tilled_soil_tilemap_layer.get_local_mouse_position()
	cell_position = tilled_soil_tilemap_layer.local_to_map(mouse_position)
	cell_source_id = tilled_soil_tilemap_layer.get_cell_source_id(cell_position)
	
	# local_cell_position bây giờ là vị trí chính giữa ô đất (đã chuyển sang tọa độ Global)
	var local_pos = tilled_soil_tilemap_layer.map_to_local(cell_position)
	local_cell_position = tilled_soil_tilemap_layer.to_global(local_pos)
	
	if player != null:
		distance = player.global_position.distance_to(local_cell_position)
	else:
		distance = INF

func add_crop() -> void:
	# Nếu khoảng cách gần (< 25) và ô đó đã được cày (source_id != -1)
	if distance < 20.0 and cell_source_id != -1:
		var crop_field = get_tree().current_scene.find_child("CropFields", true, false)
		if crop_field == null: return
		
		# Kiểm tra xem ô này đã có cây chưa để tránh trồng đè
		for old_crop in crop_field.get_children():
			if old_crop.global_position.distance_to(local_cell_position) < 5.0:
				return

		var instance: Node2D = null
		if ToolManager.selected_tool == DataTypes.Tools.PlantCorn:
			instance = corn_plant_scene.instantiate()
		elif ToolManager.selected_tool == DataTypes.Tools.PlantTomato:
			instance = tomato_plant_scene.instantiate()
			
		if instance:
			instance.global_position = local_cell_position
			crop_field.add_child(instance)

func remove_crop() -> void:
	if distance < 20.0:
		var crop_field = get_tree().current_scene.find_child("CropFields", true, false)
		if crop_field == null: return
		
		for node: Node2D in crop_field.get_children():
			# Nếu vị trí cây trùng với vị trí chuột click
			if node.global_position.distance_to(local_cell_position) < 5.0:
				node.queue_free()
