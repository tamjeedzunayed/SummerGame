extends Node
class_name Appliance

#attributes:
@export var price: float 
@export var icon: CompressedTexture2D
@export var capacity: int
@export var usedCapacity: int
@export var applianceType: String
signal capacity_changed(new_capacity)
signal usedCapacity_changed(new_capacity)

func _init (item_name: String, priceC: float, storage_capacity: int, used_capacity: int, iconC: CompressedTexture2D,  appliance_type: String):
	name = item_name
	price = priceC
	capacity = storage_capacity
	usedCapacity = used_capacity
	icon = iconC
	applianceType = appliance_type

func set_capacity(new_capacity):
	capacity = new_capacity
	emit_signal("capacity_changed", capacity)
func set_usedCapacity(new_capacity):
	usedCapacity = new_capacity
	emit_signal("usedCapacity_changed", usedCapacity)
