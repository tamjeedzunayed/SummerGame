extends Button

@onready var texture_rect = $TextureRect
@export var items : Array[Item]
@export var level : int = 1
@export var cred: int = 20
@export var discountUpgrade : int = 0
@export var itemQualityUpgrade : int = 0
@export var cartUpgrade : int = 0
@onready var big_seller_pic_display = %BigSellerPicDisplay
@onready var cred_bar = %CredBar
@onready var label = %Label
@onready var item_container = %"Item container"
@onready var discount_bar = $"../../../Items On Sale/MarginContainer/HBoxContainer/VBoxContainer2/Discount Upgrade/Discount Bar"
@onready var sell_value_bar = $"../../../Items On Sale/MarginContainer/HBoxContainer/VBoxContainer2/Sell Value Upgrade/Sell Value Bar"
@onready var shopping_cart_bar = $"../../../Items On Sale/MarginContainer/HBoxContainer/VBoxContainer2/Shopping Cart Upgrade/Shopping Cart Bar"

const ITEM_IN_SHOP_BUTTON = preload("res://Scenes/Item_in_shop_button.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
#func _init(ItemsList):
	#items = ItemsList

func _on_pressed():
	for child in item_container.get_children():
		child.queue_free()
	
	cred_bar.value = cred
	big_seller_pic_display.texture = icon
	var buttonGroup = ButtonGroup.new()
	label.text = text + " 
	
Reputation Level:"
	for item in items:
		var newButton = ITEM_IN_SHOP_BUTTON.instantiate()
		newButton.itemHeld = item
		newButton.button_group = buttonGroup
		item_container.add_child(newButton)
	
	discount_bar.value = discountUpgrade * 10
	sell_value_bar.value = itemQualityUpgrade * 10
	shopping_cart_bar.value = cartUpgrade * 10
	pass # Replace with function body.
