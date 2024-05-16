extends Button

@onready var texture_rect = $TextureRect
@export var items : Array[Item]
@export var level : int = 1
@export var cred: int = 0
@export var discountUpgrade : int = 0
@export var itemQualityUpgrade : int = 0
@export var cartUpgrade : int = 0
@export var expPoints : int = 0
