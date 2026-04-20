extends Area2D

@export var itemRes: InventoryItem

func collect(inventory: Inventory, player = null):
	if inventory.has_method("collect"):
		inventory.collect(itemRes)
		queue_free()
