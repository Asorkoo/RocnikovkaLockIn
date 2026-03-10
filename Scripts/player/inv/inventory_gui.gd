extends Control

@onready var inventory: Inventory = load("res://inventory/player_inventory.tres")
@onready var slots: Array = $NinePatchRect/VBoxContainer.get_children()

func _ready():
	inventory.updated.connect(update)
	update()

func update():
	for i in range(slots.size()):
		slots[i].update(inventory.items[i] if i < inventory.items.size() else null)
