extends Node
class_name Item


#attributes:
@export var price: float 
@export var sellPrice: float 
@export var expe: float 
@export var icon: CompressedTexture2D

#constructor:
func _init (nameP: String, priceC: float, sellPriceC: float, expC: float, iconC: CompressedTexture2D):
	name = nameP
	price = priceC
	sellPrice = sellPriceC
	expe = expC
	icon = iconC
