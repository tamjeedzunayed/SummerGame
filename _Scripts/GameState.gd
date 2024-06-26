extends Node


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
var ready_done = false
@onready var appliances_storage = $AppliancesStorage

var balance: 
	set(value):
		balance_display.text = str(value)
		balance = value
		shop.supply_connections.balance = value
const ITEM_IN_SHOP_BUTTON = preload("res://Scenes/Item_in_shop_button.tscn")


var incRate : float = 1.05
const CUSTSPAWNRATE = 5
const CUSINCRATE = 1
const QUOTINCRATE = 100
@export var DAY_TIME_LENGTH : float = 20.
@export var NIGHT_TIME_LENGTH : float = 10.

var isDay:bool = true
var numCustomers = 0
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
	cust_spawn_rate.wait_time = CUSTSPAWNRATE
	clock.wait_time = DAY_TIME_LENGTH
	clock.start()
	Canvas_animation_player.speed_scale = 1./DAY_TIME_LENGTH
	Canvas_animation_player.play("Day animation")
	
	shop.supply_connections.connect("ItemsBought", itemsBought)
	shop.supply_connections.connect("balanceChanged", changeBalance)
	truck.connect("item_for_truck", updateTruckStorage)
	for child in appliances.get_children():
		appliances_storage.addAppliance(child)
	day()
	
	pass # Replace with function body.

func customerApplinace(item:Item, customer : CharacterBody2D):
	for applianceNode in appliances.get_children():
		if applianceNode.appliance.hasItem(item):
			customer.getItemFromAppliance(applianceNode)
			return
	customer.goThroughShopingList()


func itemsBought(items):
	truck.addToCart(items)

func updateTruckStorage(storage):
	truck_storage.setItems(storage)
	truck_storage.truckHealth = truck.health
	truck_storage.DriverSalary = DriverSalary
	truck_storage.Capacity = shop.storageCapacity
	truck_storage.UsedCapacity = shop.storageCapacityUsed
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var secs = fmod(clock.time_left,60)
	var mins = fmod(clock.time_left, 60*60) / 60
	var time_passed = "%02d : %02d" % [mins,secs]
	clockButton.text = time_passed
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
	
	var customer1 = customerResource.instantiate()
	customer1.position = Vector2(1286, 451)
	customer1.connect("findAppliance", customerApplinace)
	customers.add_child(customer1)
	
	truck.day()
	shop.day()
	DriverSalary = DriverSalary*incRate
	numCustomers += CUSINCRATE
	endOfDayQuota += QUOTINCRATE
	Canvas_animation_player.play("Day animation")

func night():
	truck.night()
	for customerN in customers.get_children():
		customerN.queue_free()
	shop.night()

func _on_cust_spawn_rate_timeout():
	if (isDay):
		var newCustomer = customerResource.instantiate()
		newCustomer.position = Vector2(5, 10)
		customers.add_child(newCustomer)
		
	
	pass # Replace with function body.

func _input(_event):
	if Input.is_action_just_pressed("LMB") && false:
		var click_pos_on_map = ground_tile_map.local_to_map(get_window().get_mouse_position())
		
		if	ground_tile_map.get_cell_tile_data(1, click_pos_on_map - Vector2i(18, 10)) != null:
			return
		
		var furniture : Node2D= furnitureResource.instantiate()
		furniture.position = ground_tile_map.map_to_local(click_pos_on_map)
		print(furniture.position.y)
		furnitures.add_child(furniture) 
		
		ground_tile_map.set_cell(1, click_pos_on_map - Vector2i(18, 10), 1, ground_tile_map.get_cell_atlas_coords(0, click_pos_on_map - Vector2i(18, 10)))
		ground_tile_map.erase_cell(0, click_pos_on_map - Vector2i(18, 10))

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
