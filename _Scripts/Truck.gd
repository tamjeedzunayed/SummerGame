extends Node

var salary = 10
var capacity = 10
var health = 10
var incRate : float = 1.05
var storage : Dictionary  = {} 
@onready var truck_body = %TruckBody

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_item(item: Item, amount: int):
	if (storage.has(item)):
		storage[item] +=  amount
	else:
		storage[item] =  amount

func day():
	salary = salary*incRate
	pass

func night():
	pass
