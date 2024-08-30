extends Button


@onready var texture_rect = $TextureRect
@export var items : Array[Item]
@export var level := 1 
@export var cred := 0 
@export var discountUpgrade := 0 
var discountUpgrades = [1 , 0.95, 0.95, 0.95, 0.95, 0.95, 0.9, 0.9, 0.9, 0.85, 0.85]
@export var itemQualityUpgrade := 0 
var itemQualityUpgrades = [1, 1.05, 1.05, 1.05, 1.05, 1.05, 1.1, 1.1, 1.1, 1.15, 1.15]
@export var bundleUpgrade := 0 
@export var expPoints := 0 
@export var numItemsUnlocked := 2 

func upgradeItemDiscount():
	for item in items:
		item.price *= discountUpgrades[discountUpgrade]
	pass

func upgradeItemQuality():
	for item in items:
		item.sellPrice *= itemQualityUpgrades[itemQualityUpgrade]
	pass

func upgradeBundleDiscount():
	##TODO
	pass
