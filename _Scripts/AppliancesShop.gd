extends Panel
@onready var appliance_type_list = %ApplianceTypeList
@onready var appliance_pic = %AppliancePic
@onready var appliance_name_label = %ApplianceNameLabel
@onready var capacity_label = %CapacityLabel
@onready var price_label = %PriceLabel
@onready var items_capable = %ItemsCapable
@onready var buy_button = %BuyButton
const SHOVEL_APPLIANCE = preload("res://Assets/shovel Appliance.png")
var appliances = [
	Appliance.new("Base Shelf V.1", 50, 20, SHOVEL_APPLIANCE, "Shelf"),
	Appliance.new("Base Shelf V.2", 75, 30, SHOVEL_APPLIANCE, "Shelf"),
	Appliance.new("Base Shelf V.3", 100, 50, SHOVEL_APPLIANCE, "Shelf"),
	Appliance.new("Vending Machine", 50, 50, SHOVEL_APPLIANCE, "Refrigerator"),
	Appliance.new("Fridge", 50, 50, SHOVEL_APPLIANCE, "Refrigerator"),
	Appliance.new("Large Fridge", 50, 50, SHOVEL_APPLIANCE, "Refrigerator"),
	Appliance.new("Small Tank", 50, 50, SHOVEL_APPLIANCE, "Fluid Tanks"),
	Appliance.new("Medium Tank", 50, 50, SHOVEL_APPLIANCE, "Fluid Tanks"),
	Appliance.new("Large Tank", 50, 50, SHOVEL_APPLIANCE, "Fluid Tanks"),
	Appliance.new("Gun Case", 50, 50, SHOVEL_APPLIANCE, "Gun Cases"),
	Appliance.new("Gun Case", 50, 50, SHOVEL_APPLIANCE, "Gun Cases"),
	Appliance.new("Gun Case", 50, 50, SHOVEL_APPLIANCE, "Gun Cases"),
]

var balance : float
signal applianceBought(appliance:Appliance)
signal balanceChanged(newBalance:float)
var applianceButtonGroup := ButtonGroup.new()
var selectedButton:
	get:
		return applianceButtonGroup.get_pressed_button()
# Called when the node enters the scene tree for the first time.
func _ready():
	var applianceCounter := 0
	for applianceType in appliance_type_list.get_children():
		for child in applianceType.get_children():
			if child.is_in_group("ApplianceButton"):
				child.connect("pressed", setApplianceInfo)
				child.button_group = applianceButtonGroup
				child.applianceHeld = appliances[applianceCounter]
				#print(child.applianceHeld, appliances[applianceCounter])
				applianceCounter += 1
	appliance_type_list.get_child(0).get_child(1).button_pressed = true
	setApplianceInfo()
	pass # Replace with function body.

func setApplianceInfo():
	appliance_name_label.text = selectedButton.applianceHeld.name
	appliance_pic.texture = selectedButton.applianceHeld.icon
	capacity_label.text = "Initial Capacity: " + str(selectedButton.applianceHeld.capacity)
	price_label.text = "Price: " + str(selectedButton.applianceHeld.price)
	var itemsArr = []
	if selectedButton.applianceHeld.type == "Shelf":
		itemsArr = ["Shovels", "Drills", "Hammers", "Flashlights"]
	elif selectedButton.applianceHeld.type ==  "Refrigerator":
		itemsArr = ["Shovels", "Drills", "Hammers", "Flashlights"]
	elif selectedButton.applianceHeld.type ==  "Fluid Tanks":
		itemsArr = ["Shovels", "Drills", "Hammers", "Flashlights"]
	elif selectedButton.applianceHeld.type ==  "Gun Cases":
		itemsArr = ["Shovels", "Drills", "Hammers", "Flashlights"]
	items_capable.text = "Items it can hold:"
	for item in itemsArr:
		items_capable.text += "-" + item + "\n"
	items_capable.text += "etc"
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_buy_button_pressed():
	if (balance >= selectedButton.applianceHeld.price):
		applianceBought.emit(selectedButton.applianceHeld)
		balanceChanged.emit(balance - selectedButton.applianceHeld.price)
	pass # Replace with function body.
