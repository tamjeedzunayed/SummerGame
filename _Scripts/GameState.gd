extends Node

@onready var transactionLabel = %TransactionLabel
@onready var furnitures = $Furnitures
@onready var customers = %Customers
@onready var customers_in_queue = %CustomersInQueue
@onready var cust_spawn_rate = $CustSpawnRate
@onready var clock = $Timer
@onready var clockButton = %ClockButton
@onready var balance_display = %balanceDisplay
@onready var canvas_modulate : CanvasModulate = $CanvasModulate
@onready var Canvas_animation_player : AnimationPlayer = canvas_modulate.get_child(0)
@onready var ground_tile_map : TileMap = $GroundTileMap
@onready var shop = $Shop
@onready var truck = $Truck
@onready var truck_storage = %TruckStorage
@onready var appliances = $Appliances
@onready var cashier_check_out = $CashierCheckOut
var mouseOnFinances : bool = false 

const applianceScene = preload("res://Scenes/appliance.tscn")
const APPLIANCE_TO_PLACE = preload("res://Scenes/appliance_to_place.tscn")

var ready_done = false
@onready var appliances_storage = %AppliancesStorage
var placingAppliance = false
var balance = 0: 
	set(value):
		transactionLabel.text = str(value-balance)
		if (value-balance) > 0: transactionLabel.text = "+" + transactionLabel.text  
		if(balance - value > 0):
			transactionLabel.add_theme_color_override("font_color", Color(255,0,0))
			transactionLabel.get_child(0).play("Transaction")
		elif(balance - value < 0):
			transactionLabel.add_theme_color_override("font_color", Color(0,255,0))
			transactionLabel.get_child(0).play("Transaction")
		
		balance_display.text = str(value)
		balance = value
		shop.supply_connections.balance = value
		shop.appliances.balance = value
		

var ItemChances = {
	Item.new("Shovel", 0, 0, 0, null, "Shelf") : 100.0,
	Item.new("Drill", 0, 0, 0, null, "Shelf") : 75.0,
	Item.new("Hammer", 0, 0, 0, null, "Shelf") : 0.0,
	Item.new("Wrench", 0, 0, 0, null, "Shelf") : 0.0,
	Item.new("Axe", 0, 0, 0, null, "Shelf") : 0.0,
}
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
var numCustomers = 2
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
	shop.supply_connections.connect("balanceChanged", transaction)
	shop.supply_connections.connect("storageUsedChanged", truck_storage.changeCapacityUsed)
	shop.appliances.connect("balanceChanged", transaction)
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
	
	customer.shopping_list.get_child(customer.checkBoxIndex).disabled = true
	customer.goThroughShopingList()

func createApplianceToPlace(applianceBought):
	shop.animation_player.play("TransOut")
	shop.inView = false
	placingAppliance = true
	var applToPlace = APPLIANCE_TO_PLACE.instantiate()
	applToPlace.applianceHeld = applianceBought
	transaction("Purchases", applianceBought.name, -applianceBought.price)
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
	var time_passed = "%01d : %02d" % [mins,secs]
	clockButton.text = time_passed
	
	if (placingAppliance):
		get_node("ApplianceToPlace").position = ground_tile_map.map_to_local(ground_tile_map.local_to_map(get_window().get_mouse_position()))
	
	pass


func _on_timer_timeout():
	if (customers_in_queue.get_child_count() + customers.get_child_count() > 0):
		clock.wait_time = 2
	else:
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
	update_item_chances()
	$DayLabel.text = "Day " + str(dayNum)
	$DayLabel/AnimationPlayer.play("FadeInOut")
	transaction("Expenses", "Driver's Salary", -DriverSalary)
	transaction("Expenses", "End Of Day Quota", -endOfDayQuota)
	truck.day()
	shop.day()
	DriverSalary = round_to_digits(DriverSalary*incRate, 2)
	updateTruckStorage()
	endOfDayQuota += QUOTINCRATE
	Canvas_animation_player.play("Day animation")

func night():
	saveDailyIncome()
	
	updateNumberOfCustomers()
	$NightLabel.get_child(0).play("FadeInOut")
	numCustomers += CUSINCRATE
	customersSpawnedToday = 0
	truck.night()
	for customerN in customers.get_children():
		customerN.queue_free()
	updateNumberOfCustomers()
	shop.night()
	

func round_to_digits(value: float, digits: int) -> float:
	var factor = pow(10, digits)
	return round(value * factor) / factor

func update_item_chances():
	var items = ItemChances.keys()
	var total_chance = 100.0 ## Needs to be higher as day goes on
	var base_increment = .2  # Base increment for each item per day
	var max_chance = total_chance / float(items.size())
	
	for i in range(items.size()):
		if dayNum > i * 5:  # Delay the introduction of each item by 10 days
			# Increment the chance slowly
			ItemChances[items[i]] = min(ItemChances[items[i]] + base_increment * (dayNum - i * 5), max_chance)
		else:
			ItemChances[items[i]] = 0.0
	
	# Normalize the chances so that their sum is 100.0
	var total = sum(ItemChances.values())
	for item in items:
		ItemChances[item] = (ItemChances[item] / total) * 100.0
	
	

func sum(values: Array) -> float:
	var total = 0.0
	for value in values:
		total += value
	return total
func _on_cust_spawn_rate_timeout():
	if (isDay):
		customersSpawnedToday += 1
		var customer = customerResource.instantiate()
		customer.position = Vector2(1286, 451)
		for item in ItemChances.keys():
			if randi()% 100 + 1 <= floor(ItemChances[item]):
				customer.shopingList.append(item)
		if customer.shopingList.is_empty():
			customer.shopingList.append(ItemChances.keys()[0])
		customer.connect("findAppliance", customerApplinace)
		customer.connect("waitForQueue", queueCustomer)
		customers.add_child(customer)
		
		if (customersSpawnedToday < numCustomers):
			cust_spawn_rate.start(randf_range((DAY_TIME_LENGTH/1.5)/(numCustomers + 1) - (DAY_TIME_LENGTH)/(5*numCustomers), (DAY_TIME_LENGTH/1.5)/(numCustomers + 1) + (DAY_TIME_LENGTH)/(5*numCustomers)))
	updateNumberOfCustomers()	
	pass # Replace with function body.

func placeAppliance():
	if Input.is_action_just_pressed("LMB"):
		var click_pos_on_map = ground_tile_map.local_to_map(get_window().get_mouse_position())
		
		if	ground_tile_map.get_cell_tile_data(1, click_pos_on_map - Vector2i(18, 10)) != null:
			return
		
		var appliance = applianceScene.instantiate()
		var newAppl = Appliance.new(get_node("ApplianceToPlace").applianceHeld.name, get_node("ApplianceToPlace").applianceHeld.price, get_node("ApplianceToPlace").applianceHeld.capacity, get_node("ApplianceToPlace").applianceHeld.icon, get_node("ApplianceToPlace").applianceHeld.type)
			#Appliance.new(newAppliance.appliance)
		appliance.appliance = newAppl
		appliance.position = ground_tile_map.map_to_local(click_pos_on_map)
		appliances.add_child(appliance) 
		get_node("ApplianceToPlace").queue_free()
		placingAppliance = false
		ground_tile_map.set_cell(1, click_pos_on_map - Vector2i(18, 10), 1, ground_tile_map.get_cell_atlas_coords(0, click_pos_on_map - Vector2i(18, 10)))
		ground_tile_map.erase_cell(0, click_pos_on_map - Vector2i(18, 10))

func _input(event):
	if placingAppliance:
		placeAppliance()
	elif event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT and mouseOnFinances:
		%Finances.visible = !%Finances.visible
		pass
	pass


func _on_buy_region_body_entered(body):
	if body is CharacterBody2D:
		var totalItemPrice = 0
		var heldItems: Array[Item] = body.heldItems
		for item in heldItems:
			totalItemPrice += item.sellPrice
			transaction("Sales", item.name, item.sellPrice)
		balance += totalItemPrice
		
	body.navigation_agent.target_position = $Exit.position
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



func _on_customers_in_queue_child_entered_tree(_node):
	if cashier_check_out.is_stopped():
		cashier_check_out.start()
	pass # Replace with function body.


func _on_cashier_check_out_timeout():
	var firstCustomer = findFirstCustomer()
	if (firstCustomer != null):
		firstCustomer.goCashier()
		cashier_check_out.start()
		customers_in_queue.remove_child(firstCustomer)
		customers.add_child(firstCustomer)
		updateNumberOfCustomers()
		if (customers_in_queue.get_child_count() > 0):
			updateQueue()
	pass # Replace with function body.
	
func findFirstCustomer():
	if (customers_in_queue.get_child_count() > 0):
		return customers_in_queue.get_child(0)
	return null
	
func queueCustomer(customer):
	customers.remove_child(customer)
	customers_in_queue.add_child(customer)
	updateNumberOfCustomers()
	var numCustomersInQueue = customers_in_queue.get_child_count()
	customer.navigation_agent.target_position = Vector2(209 + 32*numCustomersInQueue, 210)

func updateQueue():
	var numCustomersInQueue = customers_in_queue.get_child_count()
	for i in range(0, numCustomersInQueue):
		customers_in_queue.get_child(i).navigation_agent.target_position = Vector2(237 + 32*i, 210)

func updateNumberOfCustomers():
	$CustomerDisplay/NumberOfCustomers.text = str($Customers.get_child_count() + customers_in_queue.get_child_count())
	pass

func _on_exit_body_entered(body):
	if body is CharacterBody2D:
		body.queue_free()
		updateNumberOfCustomers()
	pass # Replace with function body.



func saveDailyIncome():
	%Finances.instantiateDailyIncome(dayNum)
	
#all transactions should happen through this function
func transaction(type : String, specific : String, amount : float):
	if (%Finances.dailyIncome != null):
		%Finances.dailyIncome.updateDailyIncome(type, specific, amount)
		balance += amount
	else:
		%Finances.instantiateDailyIncome(dayNum)
		transaction(type, specific, amount)

func _on_Finances_button_pressed():
	%Finances.visible = !%Finances.visible
	pass # Replace with function body.
