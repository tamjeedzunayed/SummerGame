extends Panel

@onready var seller_list = %SellerList
@onready var item_information = %"Item Information"
@onready var cred_bar = %CredBar
@onready var big_seller_pic_display = %BigSellerPicDisplay
@onready var item_container = %"Item container"
@onready var discount_bar = %"Discount Bar"
@onready var sell_value_upgrade_button = %SellValueUpgradeButton
@onready var bundle_upgrade_button = %BundleUpgradeButton
@onready var discount_button = %"Discount Button"
@onready var sell_value_bar = %"Sell Value Bar"
@onready var bundleUpgrade_bar = %"Shopping Cart Bar"
@onready var exp_points = %"EXP points"
@onready var exp_icon = %EXPIcon
@onready var expPoints = 0
@onready var total_label = %TotalLabel
@onready var seller_name_label = %SellerNameLabel
@onready var add_to_cart = %"Add to Cart"
var balance: float

signal ItemsBought(Items : Dictionary)
signal StorageFull
signal balanceChanged(type : String, specific : String, newBalance)
signal storageUsedChanged(newUsedCapacitiy)

var ItemButtonGroup = ButtonGroup.new()
var SellerButtonGroup :=  ButtonGroup.new()
const MULTIPLYER = 1
const ITEM_IN_SHOP_BUTTON = preload("res://Scenes/Item_in_shop_button.tscn")
var cart : Dictionary
var storageCapacity := 20
var storageCapacityUsed := 0:
	set(value):
		if (value) == storageCapacity:
			add_to_cart.disabled = true
			StorageFull.emit()
		else:
			add_to_cart.disabled = false
		storageCapacityUsed = value
		
var cartTotal := 0:
	set(value):
		total_label.text = "Total: $" + str(value)
		cartTotal = value
var currentSeller:
	get:
		return SellerButtonGroup.get_pressed_button()


# Called when the node enters the scene tree for the first time.
func _ready():
	SellerButtonGroup = seller_list.get_child(0).button_group
	seller_list.get_child(0).button_pressed = true
	
	var seller1items : Array[Item] = [Item.new("Shovel", 10,15,10, preload("res://Assets/Shovel.png"), "Shelf"),
	Item.new("Drill", 10,12,10, preload("res://Assets/Drill.png"), "Shelf"),
	Item.new("Hammer", 10,12,10, preload("res://Assets/Hammer.png"), "Shelf"),
	Item.new("Wrench", 10,12,10, preload("res://Assets/Wrench.png"), "Shelf"),
	Item.new("Axe", 10,12,10, preload("res://Assets/Axe.png"), "Shelf")]
	currentSeller.items = seller1items
	
	for sellerChild in seller_list.get_children():
		sellerChild.connect("pressed", setSellerInfo)
	
	setSellerInfo()
	pass # Replace with function body.

func setSellerInfo():
	for child in item_container.get_children():
		child.queue_free()
	
	seller_name_label.text = currentSeller.text
	cred_bar.value = currentSeller.cred
	big_seller_pic_display.texture = currentSeller.icon
	for item in currentSeller.items:
		var newButton = ITEM_IN_SHOP_BUTTON.instantiate()
		newButton.button_group = ItemButtonGroup
		item_container.add_child(newButton)
		newButton.amount = 0
		newButton.itemHeld = item 
		newButton.connect("toggled", setItemInfo)
	
	item_container.get_child(0).button_pressed = true
	discount_bar.value = currentSeller.discountUpgrade
	sell_value_bar.value = currentSeller.itemQualityUpgrade
	bundleUpgrade_bar.value = currentSeller.bundleUpgrade
	expPoints = currentSeller.expPoints
	
	if (currentSeller.expPoints):
		exp_points.text = "EXP Points: " + str(currentSeller.expPoints)
		exp_icon.texture = preload("res://Assets/Exp.png")
	
	pass

func setItemInfo(_toggled):
	var itemButton = ItemButtonGroup.get_pressed_button()
	item_information.text = itemButton.itemHeld.name + "
	
	Price: $" + str(itemButton.itemHeld.price) + "
	Sell Value: $" + str(itemButton.itemHeld.sellPrice) +"
	Exp: " + str(itemButton.itemHeld.expe) + "xp"

func _on_add_to_cart_pressed():
	if (ItemButtonGroup.get_pressed_button().amount != 10):
		if cart.has(ItemButtonGroup.get_pressed_button().itemHeld):
			cart[ItemButtonGroup.get_pressed_button().itemHeld] += 1 
		else:
			cart[ItemButtonGroup.get_pressed_button().itemHeld] = 1
		ItemButtonGroup.get_pressed_button().amount += 1
		cartTotal += ItemButtonGroup.get_pressed_button().itemHeld.price
		storageUsedChanged.emit(storageCapacityUsed + 1)
	pass # Replace with function body.

func _on_remove_from_cart_pressed():
	if (ItemButtonGroup.get_pressed_button().amount != 0):
		cart[ItemButtonGroup.get_pressed_button().itemHeld] -= 1
		if cart[ItemButtonGroup.get_pressed_button().itemHeld] == 0:
			cart.erase(ItemButtonGroup.get_pressed_button().itemHeld)
		ItemButtonGroup.get_pressed_button().amount -= 1
		cartTotal -= ItemButtonGroup.get_pressed_button().itemHeld.price
		storageUsedChanged.emit(storageCapacityUsed - 1)
		
	pass # Replace with function body.
	

func _on_buy_pressed():
	if (balance >= cartTotal):
		var totalXpAdded := 0.
		for item in cart.keys():
			balanceChanged.emit("Purchases", item.name , -item.price*cart[item])
			totalXpAdded += item.expe * cart[item]
		for itemButton in ItemButtonGroup.get_buttons():
			itemButton.amount = 0
		currentSeller.cred += totalXpAdded
		cred_bar.value += totalXpAdded
		
		if (cred_bar.value >= cred_bar.max_value):
			currentSeller.expPoints += int(cred_bar.value/cred_bar.max_value)
			currentSeller.level += int(cred_bar.value/cred_bar.max_value)
			cred_bar.value = int(cred_bar.value) % int(cred_bar.max_value)
			cred_bar.max_value *= MULTIPLYER
			exp_points.text = "EXP Points: " + str(currentSeller.expPoints)
			exp_icon.texture = preload("res://Assets/Exp.png")
		currentSeller.cred = currentSeller.cred % int(cred_bar.max_value)
		ItemsBought.emit(cart)
		
		cart.clear()
		cartTotal = 0
	pass # Replace with function body.

func _on_discount_button_pressed():
	if(currentSeller.discountUpgrade < 10 && currentSeller.expPoints > 0):
		currentSeller.discountUpgrade += 1
		currentSeller.expPoints -= 1
		discount_bar.value = currentSeller.discountUpgrade
		exp_points.text = "EXP Points: " + str(SellerButtonGroup.get_pressed_button().expPoints)
		currentSeller.upgradeItemDiscount()
		setSellerInfo()
func _on_sell_value_upgrade_button_pressed():
	if(currentSeller.itemQualityUpgrade < 10 && currentSeller.expPoints > 0):
		currentSeller.itemQualityUpgrade += 1
		currentSeller.expPoints -= 1
		sell_value_bar.value = currentSeller.itemQualityUpgrade
		exp_points.text = "EXP Points: " + str(SellerButtonGroup.get_pressed_button().expPoints)
		currentSeller.upgradeItemQuality()
		setSellerInfo()
	pass # Replace with function body.

func _on_bundle_upgrade_button_pressed():
	if(currentSeller.bundleUpgrade < 10 && currentSeller.expPoints > 0):
		currentSeller.bundleUpgrade += 1
		currentSeller.expPoints -= 1
		bundleUpgrade_bar.value = currentSeller.bundleUpgrade
		exp_points.text = "EXP Points: " + str(SellerButtonGroup.get_pressed_button().expPoints)
		currentSeller.upgradeBundleDiscount()
		setSellerInfo()
	pass # Replace with function body.
