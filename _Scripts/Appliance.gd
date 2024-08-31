extends Node
class_name Appliance

#attributes:
@export var price: float
@export var capacity: int
@export var usedCapacity: int = 0
@export var type: String
@export var storage : Dictionary = {}
var icon
signal capacity_changed(new_capacity)
signal usedCapacity_changed(new_capacity)
signal update(appliance)

func _init (appliance_name: String, priceC: float, storage_capacity: int, iconC: CompressedTexture2D,  appliance_type: String):
	name = appliance_name
	price = priceC
	capacity = storage_capacity
	icon = iconC
	type = appliance_type

func hasItem(item : Item) -> bool:
	for storageItem in storage:
		if storageItem.name == item.name && storage[storageItem] > 0:
			return true
	return false

func retrieveItem(item:Item) -> Item:
	for storageItem in storage:
		if storageItem.name == item.name && storage[storageItem] > 0:
			storage[storageItem] -= 1
			usedCapacity -= 1
			emit_signal("usedCapacity_changed", usedCapacity)
			update.emit(self)
			return storageItem
	return null

func set_capacity(new_capacity):
	capacity = new_capacity
	emit_signal("capacity_changed", capacity)
	

func addItem(item:Item, numItem):
	if (storage.has(item)):
		storage[item] = storage[item] + numItem
	else:
		storage[item] = numItem
	usedCapacity += numItem
	emit_signal("usedCapacity_changed", usedCapacity)
	update.emit(self)
	
