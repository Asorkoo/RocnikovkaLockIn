extends Control

@onready var inventory: Inventory = preload("res://inventory/player_inventory.tres")
@onready var slots: Array = $NinePatchRect/VBoxContainer.get_children()

func _ready():
	update()

func update():
	for i in range(min(inventory.items.size(), slots.size())):
		slots[i].update(inventory.items[i])
