extends Area2D

@export var req_item: InventoryItem
@onready var inventory: Inventory = load("res://inventory/player_inventory.tres")
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var label: Label = $Label

var unlocked := false

func _ready():
	sprite.frame = 0
	label.visible = false

func _on_body_entered(body):

	if unlocked:
		return
	
	if has_isic():
		unlock_door()

func has_isic() -> bool:
	for item in inventory.items:
		if item == req_item:
			return true
	return false

func unlock_door():
	unlocked = true
	sprite.frame = 1
	collision.disabled = true
	show_label()
	
func show_label():
	label.visible = true
	await get_tree().create_timer(1.0).timeout
	label.visible = false
