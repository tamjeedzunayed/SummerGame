extends CanvasLayer
@onready var panel = $Panel
@onready var animation_player = $AnimationPlayer
@onready var button = $Button
@export var itsDay = false
@export var inView = false

@onready var seller = $"Panel/TabContainer/Supply Connections/Supply Connections/GridContainer/ScrollContainer/VBoxContainer/Seller"
const SHOVEL = preload("res://Assets/Shovel.png")
@onready var v_box_container = $"Panel/TabContainer/Supply Connections/Supply Connections/GridContainer/ScrollContainer/VBoxContainer"
@onready var item_information = %"Item Information"
@onready var cred_bar = %CredBar
@onready var big_seller_pic_display = %BigSellerPicDisplay
@onready var item_container = %"Item container"
@onready var discount_bar = %"Discount Bar"
@onready var sell_value_bar = %"Sell Value Bar"
@onready var shopping_cart_bar = %"Shopping Cart Bar"
const ITEM_IN_SHOP_BUTTON = preload("res://Scenes/Item_in_shop_button.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	var shovel = Item.new(10,10,10, SHOVEL)
	var shovel2 = Item.new(10,12,10, SHOVEL)
	seller.items.append(shovel)
	seller.items.append(shovel2)
	
	for child in v_box_container.get_children():
		child.connect("seller_pressed", setSellerInfo)
	pass # Replace with function body.

func setSellerInfo(SellerInfo):
	for child in item_container.get_children():
		child.queue_free()
		
	cred_bar.value = SellerInfo.cred
	big_seller_pic_display.texture = SellerInfo.icon
	
	var buttonGroup = ButtonGroup.new()
	for item in SellerInfo.items:
		var newButton = ITEM_IN_SHOP_BUTTON.instantiate()
		newButton.itemHeld = item
		newButton.button_group = buttonGroup
		item_container.add_child(newButton)
	
	discount_bar.value = SellerInfo.discountUpgrade * 10
	sell_value_bar.value = SellerInfo.itemQualityUpgrade * 10
	shopping_cart_bar.value = SellerInfo.cartUpgrade * 10
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_button_pressed():
	if(inView):
		animation_player.play("TransOut")
		inView = false
	else:
		animation_player.play("TransIn")
		inView = true
	pass # Replace with function body.



