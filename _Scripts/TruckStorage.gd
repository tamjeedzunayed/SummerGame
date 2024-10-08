extends Panel
@onready var truck_storage_button = $"Truck Storage Button"
@onready var truck_health = %"Truck Health"
@onready var animation_player = $AnimationPlayer
var truck_storage_in_display = false
@onready var truck_item_list = %TruckItemList
@onready var driver_salary = %"Driver Salary"
@onready var capacity = %Capacity
@onready var used_capacity = %"Used Capacity"
@onready var item_displayed = %ItemInfo
@onready var item_picture = %ItemPicture
@onready var drag_amount = %"Drag Amount"

var ItemButtonGroup = ButtonGroup.new()

var ItemStorage = {Item.new("Shovel", 10.0, 15.0, 10, preload("res://Assets/Shovel.png"),"Shelf"):10}
var truckHealth: 
	set(value): 
		truck_health.text = "Truck Health: " + str(value)
		truckHealth = value
var DriverSalary:
	set(value):
		driver_salary.text = "Driver Salary: " + str(round(value * pow(10, 5)) / pow(10, 5))
		DriverSalary = value
var UsedCapacity = 0:
	set(value):
		used_capacity.text = "Used Capacity: " + str(value)
		UsedCapacity = value
		UsedCapacityChanged.emit(value)
var Capacity:
	set(value):
		capacity.text = "Capacity: " + str(value)
		Capacity = value

signal UsedCapacityChanged(newUsedCapacity)
const ITEM_IN_TRUCK_STORAGE = preload("res://Scenes/Item_Dragging/Item_in_truck_storage.tscn")
# Called when the node enters the scene tree for the first time.

func _ready():
	for v in ItemStorage.values():
		UsedCapacity+=v
	Capacity = 20
	
	#animation_player.play("Panel_Out")	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func changeCapacityUsed(newUsedCapacity):
	UsedCapacity = newUsedCapacity

func setItems():
	for item in ItemStorage.keys():
		if ItemStorage[item] == 0:
			continue
		var added = false
		for child in truck_item_list.get_children():
			if child.itemHeld.name == item.name && child.itemHeld.sellPrice == item.sellPrice:
				child.amount = ItemStorage[item]
				added = true
				break
		if added: continue
		var newButton = ITEM_IN_TRUCK_STORAGE.instantiate()
		newButton.dragItemAmount = drag_amount.value 
		truck_item_list.add_child(newButton)
		newButton.itemHeld = item 
		newButton.amount = ItemStorage[item]
		newButton.button_group = ItemButtonGroup
		newButton.connect("toggled", setItemInfo)
		newButton.connect("updateAmount", updateStorage)

func updateStorage(itemChanged, newAmount):
	for item in ItemStorage.keys():
		if (item.name == itemChanged.name) && (item.sellPrice == itemChanged.sellPrice):
			UsedCapacity += newAmount - ItemStorage[item]
			ItemStorage[item] = newAmount
			return

func _on_truck_storage_button_pressed():
	if (!truck_storage_in_display):
		animation_player.play("Panel_In")
		truck_storage_in_display = true
	else:
		animation_player.play("Panel_Out")
		truck_storage_in_display = false
	pass # Replace with function body.

func setItemInfo(_toggled):
	var itemToggled : Item = ItemButtonGroup.get_pressed_button().itemHeld
	
	item_displayed.text = "Item Name: " + itemToggled.name + " 
	 SalePrice: " + str(itemToggled.sellPrice) + "
	 Buy Cost: " + str(itemToggled.price)+ "
	 Appliance Type: " + itemToggled.applianceType 
	item_picture.texture = itemToggled.icon
	pass

func _on_drag_amount_value_changed(value):
	drag_amount.value = value
	var dragAmount = value
	for iteminlist in truck_item_list.get_children():
		iteminlist.dragItemAmount = dragAmount 
	pass # Replace with function body.
