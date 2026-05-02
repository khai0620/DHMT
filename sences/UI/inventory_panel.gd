extends PanelContainer

@onready var log_label: Label = $MarginContainer/VBoxContainer/Logs/LogLabel
@onready var stone_label: Label = $MarginContainer/VBoxContainer/Stone/StoneLabel
@onready var corn_label: Label = $MarginContainer/VBoxContainer/Corn/CornLabel
@onready var tomato_label: Label = $MarginContainer/VBoxContainer/Tomato/TomatoLabel
@onready var egg_label: Label = $MarginContainer/VBoxContainer/Egg/EggLabel

func _ready() -> void:
	InventoryManager.inventory_changed.connect(on_inventory_changed)
	
	on_inventory_changed()

func on_inventory_changed() -> void:
	var inventory: Dictionary = InventoryManager.inventory
	
	if inventory.has("log"):
		log_label.text = str(inventory["log"])
		
	if inventory.has("stone"):
		stone_label.text = str(inventory["stone"])
		
	if inventory.has("cornhavest"):
		corn_label.text = str(inventory["cornhavest"])
		
	if inventory.has("tomatohavest"):
		tomato_label.text = str(inventory["tomatohavest"])
	
	if inventory.has("egg"):
		egg_label.text = str(inventory["egg"])
