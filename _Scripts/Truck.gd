extends Node

var health := 10

var cart : Dictionary = {}
var onSupplyRun : bool = true
var supplyRunDuration := 1
@onready var truck_body = %TruckBody
@onready var animation_player = $AnimationPlayer

signal addToStorage(storage)

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.speed_scale = 0.5
	#animation_player.play("Drive_Truck_in")
	pass # Replace with function body.

func addToCart(items : Dictionary):
	for item in items.keys():
		if cart.has(item):
			cart[item] += items[item]
		else:
			cart[item] = items[item]


func supplyRun():
	onSupplyRun = true
	animation_player.play("Drive_Truck_out")
	supplyRunDuration = 1
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func day():
	if !cart.is_empty():
		supplyRun()
	pass

func night():
	if onSupplyRun:
		supplyRunDuration -= 1
	if supplyRunDuration == 0 && onSupplyRun:
		animation_player.play("Drive_Truck_in")
		add_items_to_Truck_Storage()
		onSupplyRun = false
	pass

func add_items_to_Truck_Storage():
	if (!cart.is_empty()):
		addToStorage.emit(cart)
		cart.clear()
	pass
