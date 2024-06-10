extends Node
class_name Item

#attributes:
@export var price: float 
@export var sellPrice: float 
@export var expe: float 
@export var icon: CompressedTexture2D
@export var applianceType: String

#constructor:
func _init (item_name: String, priceC: float, sellPriceC: float, expC: float, iconC: CompressedTexture2D,  appliance_type: String):
	name = item_name
	price = priceC
	sellPrice = sellPriceC
	expe = expC
	icon = iconC
	applianceType = appliance_type


