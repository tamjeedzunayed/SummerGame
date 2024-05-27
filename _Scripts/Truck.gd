extends Node

var health := 10
var storage : Dictionary  = {} 
var cart : Dictionary = {}
var onSupplyRun : bool = true
var supplyRunDuration := 0
@onready var truck_body = %TruckBody
@onready var animation_player = $AnimationPlayer

signal item_for_truck(storage)

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.speed_scale = 0.5
	pass # Replace with function body.

func addToCart(items : Dictionary):
	for item in items.keys():
		if cart.has(item):
			cart[item] += items[item]
		else:
			cart[item] = items[item]

func getItemsInCart():
	for item in cart.keys():
		add_item(item, cart[item])
	cart.clear()

func supplyRun():
	onSupplyRun = true
	animation_player.play("Drive_Truck_out")
	supplyRunDuration = 1
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func add_item(item: Item, amount: int):
	if (storage.has(item)):
		storage[item] +=  amount
	else:
		storage[item] =  amount

func day():
	if !cart.is_empty():
		supplyRun()
	if onSupplyRun:
		supplyRunDuration -= 1
	pass

func night():
	if supplyRunDuration == 0 && onSupplyRun:
		animation_player.play("Drive_Truck_in")
		add_items_to_Truck_Storage()
		onSupplyRun = false
	pass

func add_items_to_Truck_Storage():
	if (!storage.is_empty()):
		emit_signal("item_for_truck", storage)
	pass
