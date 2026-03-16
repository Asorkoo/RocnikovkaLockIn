extends Area2D

@export var itemRes: InventoryItem

func collect(inventory: Inventory, player = null):
	inventory.insert_into_inventory(itemRes)
	queue_free()
