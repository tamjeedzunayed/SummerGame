extends Node
class_name Item


#attributes:
@export var price: float 
@export var sellPrice: float 
@export var expe: float 
@export var icon: CompressedTexture2D

#constructor:
func _init (priceC: float, sellPriceC: float, expC: float, iconC: CompressedTexture2D):
	price = priceC
	sellPrice = sellPriceC
	expe = expC
	icon = iconC
