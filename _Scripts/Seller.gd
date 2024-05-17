extends Button


@onready var texture_rect = $TextureRect
@export var items : Array[Item]
@export var level := 1 
@export var cred := 0 
@export var discountUpgrade := 0 
@export var itemQualityUpgrade := 0 
@export var cartUpgrade := 0 
@export var expPoints := 0 
@export var numItemsUnlocked := 2 

