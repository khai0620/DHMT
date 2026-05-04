extends Node2D

class_name FieldCursorComponent

@export var grass_tilemap_layer: TileMapLayer
@export var tilled_soil_tilemap_layer: TileMapLayer
@export var terrain_set: int = 0
@export var terrain: int = 3

var player: Node2D = null
var mouse_position: Vector2
var cell_position: Vector2i
var cell_source_id: int
var local_cell_position: Vector2
var distance: float

func _ready() -> void:
	# Tự động tìm Player trong Group hoặc tìm theo tên
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		player = get_tree().current_scene.find_child("Player", true, false)
	
	# Tự động tìm Layer nếu Inspector bị trống (Sửa lỗi null ở Map mới)
	if grass_tilemap_layer == null:
		grass_tilemap_layer = get_tree().current_scene.find_child("grass", true, false) as TileMapLayer
		
	if tilled_soil_tilemap_layer == null:
		tilled_soil_tilemap_layer = get_tree().current_scene.find_child("TilledSoil", true, false) as TileMapLayer

func _unhandled_input(event: InputEvent) -> void:
	# Kiểm tra công cụ và nút bấm (Action "hit" cho cày, "remove_dirt" cho xóa)
	if event.is_action_pressed("hit"):
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_cell_under_mouse()
			add_tilled_soil_cell()
	
	if event.is_action_pressed("remove_dirt"):
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_cell_under_mouse()
			remove_tilled_soil_cell()

func get_cell_under_mouse() -> void:
	# Bảo vệ tránh lỗi "on a null value" nếu không tìm thấy layer
	if grass_tilemap_layer == null: 
		return
		
	mouse_position = grass_tilemap_layer.get_local_mouse_position()
	cell_position = grass_tilemap_layer.local_to_map(mouse_position)
	cell_source_id = grass_tilemap_layer.get_cell_source_id(cell_position)
	local_cell_position = grass_tilemap_layer.map_to_local(cell_position)
	
	if player != null:
		var global_cell_pos = grass_tilemap_layer.to_global(local_cell_position)
		distance = player.global_position.distance_to(global_cell_pos)
	else:
		distance = 0.0

func add_tilled_soil_cell() -> void:
	if tilled_soil_tilemap_layer == null: 
		return
		
	# Khoảng cách 25 pixel và phải click trúng vào lớp cỏ (source != -1)
	if distance < 20.0 and cell_source_id != -1:
		tilled_soil_tilemap_layer.set_cells_terrain_connect([cell_position], terrain_set, terrain, true)

func remove_tilled_soil_cell() -> void:
	if tilled_soil_tilemap_layer == null: 
		return
		
	if distance < 20.0:
		# Đặt terrain về -1 để xóa ô đất cày
		tilled_soil_tilemap_layer.set_cells_terrain_connect([cell_position], terrain_set, -1, true)
