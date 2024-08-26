extends Node

@onready var transaction = $Transaction
@onready var furnitures = $Furnitures
@onready var customers = %Customers
@onready var cust_spawn_rate = $CustSpawnRate
@onready var clock = $Timer
@onready var clockButton = $CanvasLayer/PanelContainer/MarginContainer/GridContainer/Button
@onready var balance_display = %balanceDisplay
@onready var canvas_modulate : CanvasModulate = $CanvasModulate
@onready var Canvas_animation_player : AnimationPlayer = canvas_modulate.get_child(0)
@onready var ground_tile_map : TileMap = $GroundTileMap
@onready var shop = $Shop
@onready var truck = $Truck
@onready var truck_storage = $"TruckStorage"
@onready var appliances = $Appliances
const applianceScene = preload("res://Scenes/appliance.tscn")
const APPLIANCE_TO_PLACE = preload("res://Scenes/appliance_to_place.tscn")

var ready_done = false
@onready var appliances_storage = $AppliancesStorage
var placingAppliance = false
var balance = 0: 
	set(value):
		transaction.text = str(value-balance)
		if (value-balance) > 0: transaction.text = "+" + transaction.text  
		if(balance - value > 0):
			transaction.add_theme_color_override("font_color", Color(255,0,0))
			transaction.get_child(0).play("Transaction")
		elif(balance - value < 0):
			transaction.add_theme_color_override("font_color", Color(0,255,0))
			transaction.get_child(0).play("Transaction")
		
		balance_display.text = str(value)
		balance = value
		shop.supply_connections.balance = value
		shop.appliances.balance = value


const ITEM_IN_SHOP_BUTTON = preload("res://Scenes/Item_in_shop_button.tscn")

var incRate : float = 1.05
var CUSTSPAWNRATE = 0
var customersSpawnedToday = 0
const CUSINCRATE = 1
const QUOTINCRATE = 5
@export var DAY_TIME_LENGTH : float = 20.
@export var NIGHT_TIME_LENGTH : float = 10.
var dayNum := 0
var isDay:bool = false
var numCustomers = 3
var rating = 5
var endOfDayQuota = 0

var DriverSalary := 10.0

var customerResource = preload("res://Scenes/customer.tscn")
var furnitureResource = preload("res://Scenes/furniture.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	ready_done = true
	balance = 200
	shop.offset = Vector2(64, -546)
	
	clock.wait_time = NIGHT_TIME_LENGTH
	clock.start()
	Canvas_animation_player.speed_scale = 1./DAY_TIME_LENGTH
	
	shop.supply_connections.connect("ItemsBought", itemsBought)
	shop.supply_connections.connect("balanceChanged", changeBalance)
	shop.supply_connections.connect("storageUsedChanged", truck_storage.changeCapacityUsed)
	shop.appliances.connect("balanceChanged", changeBalance)
	shop.appliances.connect("applianceBought", createApplianceToPlace)
	truck_storage.connect("UsedCapacityChanged", shop.usedCapacityChanged)
	shop.usedCapacityChanged(truck_storage.UsedCapacity)
	truck.connect("addToStorage", collectSupplyRun)
	for child in appliances.get_children():
		appliances_storage.addAppliance(child)
	night()
	updateTruckStorage()
	pass # Replace with function body.

func customerApplinace(item:Item, customer : CharacterBody2D):
	for applianceNode in appliances.get_children():
		if applianceNode.appliance.hasItem(item):
			customer.getItemFromAppliance(applianceNode)
			return
	customer.goThroughShopingList()

func createApplianceToPlace(applianceBought):
	shop.animation_player.play("TransOut")
	shop.inView = false
	placingAppliance = true
	var applToPlace = APPLIANCE_TO_PLACE.instantiate()
	applToPlace.applianceHeld = applianceBought
	add_child(applToPlace)
	pass

func itemsBought(items):
	truck.addToCart(items)

func collectSupplyRun(newItems):
	for item in newItems.keys():
		var added = false
		for itemInStorage in truck_storage.ItemStorage.keys():
			if (itemInStorage.name == item.name) && (itemInStorage.sellPrice == item.sellPrice):
				truck_storage.ItemStorage[itemInStorage] = truck_storage.ItemStorage[itemInStorage] + newItems[item]
				print("collectSupplyRun ", truck_storage.ItemStorage[itemInStorage])
				added = true
				break
		if added: continue
		truck_storage.ItemStorage[item] = newItems[item]
	updateTruckStorage()

func updateTruckStorage():
	truck_storage.setItems()
	truck_storage.truckHealth = truck.health
	truck_storage.DriverSalary = DriverSalary
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var secs = fmod(clock.time_left,60)
	var mins = fmod(clock.time_left, 60*60) / 60
	var time_passed = "%02d : %02d" % [mins,secs]
	clockButton.text = time_passed
	
	if (placingAppliance):
		get_node("ApplianceToPlace").position = ground_tile_map.map_to_local(ground_tile_map.local_to_map(get_window().get_mouse_position()))
	
	
	pass


func _on_timer_timeout():
	isDay = !isDay
	if (isDay):
		clock.wait_time = DAY_TIME_LENGTH
		day()
	else:
		clock.wait_time = NIGHT_TIME_LENGTH
		night()
	clock.start()
	pass # Replace with function body.

func day():
	cust_spawn_rate.start(randf_range((DAY_TIME_LENGTH/1.5)/(numCustomers + 1) - (DAY_TIME_LENGTH)/(5*numCustomers), (DAY_TIME_LENGTH/1.5)/(numCustomers + 1) + (DAY_TIME_LENGTH)/(5*numCustomers)))
	dayNum+=1
	$DayLabel.text = "Day " + str(dayNum)
	$DayLabel/AnimationPlayer.play("FadeInOut")
	balance -= DriverSalary+endOfDayQuota
	truck.day()
	shop.day()
	DriverSalary = round_to_digits(DriverSalary*incRate, 2)
	updateTruckStorage()
	endOfDayQuota += QUOTINCRATE
	Canvas_animation_player.play("Day animation")

func night():
	$NightLabel.get_child(0).play("FadeInOut")
	numCustomers += CUSINCRATE
	customersSpawnedToday = 0
	truck.night()
	for customerN in customers.get_children():
		customerN.queue_free()
	shop.night()

func round_to_digits(value: float, digits: int) -> float:
	var factor = pow(10, digits)
	return round(value * factor) / factor

func _on_cust_spawn_rate_timeout():
	if (isDay):
		customersSpawnedToday += 1
		var customer1 = customerResource.instantiate()
		customer1.position = Vector2(1286, 451)
		customer1.connect("findAppliance", customerApplinace)
		customers.add_child(customer1)
		
		if (customersSpawnedToday < numCustomers):
			cust_spawn_rate.start(randf_range((DAY_TIME_LENGTH/1.5)/(numCustomers + 1) - (DAY_TIME_LENGTH)/(5*numCustomers), (DAY_TIME_LENGTH/1.5)/(numCustomers + 1) + (DAY_TIME_LENGTH)/(5*numCustomers)))
			
	pass # Replace with function body.

func placeAppliance():
	if Input.is_action_just_pressed("LMB"):
		var click_pos_on_map = ground_tile_map.local_to_map(get_window().get_mouse_position())
		
		if	ground_tile_map.get_cell_tile_data(1, click_pos_on_map - Vector2i(18, 10)) != null:
			return
		
		var appliance = applianceScene.instantiate()
		appliance.appliance = get_node("ApplianceToPlace").applianceHeld
		appliance.position = ground_tile_map.map_to_local(click_pos_on_map)
		appliances.add_child(appliance) 
		get_node("ApplianceToPlace").queue_free()
		placingAppliance = false
		ground_tile_map.set_cell(1, click_pos_on_map - Vector2i(18, 10), 1, ground_tile_map.get_cell_atlas_coords(0, click_pos_on_map - Vector2i(18, 10)))
		ground_tile_map.erase_cell(0, click_pos_on_map - Vector2i(18, 10))

func _input(_event):
	if placingAppliance:
		placeAppliance()

func changeBalance(newBalance):
	balance = newBalance

func _on_buy_region_body_entered(body):
	if body is CharacterBody2D:
		var totalItemPrice = 0
		var heldItems: Array[Item] = body.heldItems
		for item in heldItems:
			totalItemPrice += item.sellPrice
		balance += totalItemPrice
	pass # Replace with function body.

func readyToGo():
	ready_done = true
	print("ran")

func _on_button_pressed():
	var newAppliance = applianceScene.instantiate()
	appliances.add_child(newAppliance)
	pass # Replace with function body.

func _on_appliances_child_entered_tree(node):
	if ready_done == true:
		appliances_storage.addAppliance(node)
	pass # Replace with function body.
