extends Node2D

@export var req_item: InventoryItem
@onready var inventory: Inventory = load("res://inventory/player_inventory.tres")
@onready var sprite: Sprite2D = $Sprite2D
@onready var blocker: StaticBody2D = $StaticBody2D
@onready var label: Label = $Label
@onready var label2: Label = $Label2

var unlocked := false

func _ready():
	sprite.frame = 0
	label.visible = false

func has_key() -> bool:
	for item in inventory.items:
		if item == req_item:
			return true
	return false

func unlock_door():
	unlocked = true
	sprite.frame = 1
	blocker.process_mode = Node.PROCESS_MODE_DISABLED
	show_label()
	
func show_label():
	label.visible = true
	await get_tree().create_timer(1.0).timeout
	label.visible = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if unlocked:
		return
	
	if !has_key():
		label2.visible = true

	
	if has_key():
		unlock_door()
