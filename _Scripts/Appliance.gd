extends Button
class_name Appliance

#attributes:
@export var price: float 
@export var capacity: int
@export var usedCapacity: int = 0
@export var type: String
@export var storage : Dictionary = {Item.new("Shovel", 10.0, 10.0, 10.0, null, "ShovelHolder"): 1}
signal capacity_changed(new_capacity)
signal usedCapacity_changed(new_capacity)

func _init (appliance_name: String, priceC: float, storage_capacity: int, iconC: CompressedTexture2D,  appliance_type: String):
	name = appliance_name
	price = priceC
	capacity = storage_capacity
	icon = iconC
	type = appliance_type

func hasItem(item : Item) -> bool:
	for storageItem in storage:
		if storageItem.name == item.name:
			return true
	return false

func retrieveItem(item:Item) -> Item:
	for storageItem in storage:
		if storageItem.name == item.name:
			storage[storageItem] -= 1
			if storage[storageItem] == 0:
				storage.erase(storageItem)
			print(storage)
			return storageItem
	return null

func set_capacity(new_capacity):
	capacity = new_capacity
	emit_signal("capacity_changed", capacity)
func set_usedCapacity(new_capacity):
	usedCapacity = new_capacity
	emit_signal("usedCapacity_changed", usedCapacity)
	
func addItem(item:Item, numItem):
	if (storage.has(item)):
		storage[item] = storage[item] + numItem
	else:
		storage[item] = numItem
