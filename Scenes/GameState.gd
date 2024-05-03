extends Node


@onready var customers = %Customers
@onready var cust_spawn_rate = $CustSpawnRate

@onready var clock = $Timer
@onready var clockButton = $Timer/Button


@onready var canvas_modulate = %CanvasModulate



const CUSTSPAWNRATE = 5
const CUSINCRATE = 1
const QUOTINCRATE = 100
const DAYTIME = 12

var isDay:bool = true
var numCustomers = 0
var rating = 5
var endOfDayQuota = 0

var customerPath = preload("res://Scenes/customer.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	cust_spawn_rate.wait_time = CUSTSPAWNRATE
	clock.wait_time = DAYTIME
	clock.start()

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	clockButton.text = str(round(clock.time_left))
	pass


func _on_timer_timeout():
	isDay = !isDay
	print(isDay)
	
	if (isDay):
		clock.wait_time = DAYTIME
		day()
	else:
		@warning_ignore("integer_division")
		clock.wait_time = DAYTIME/3
		night()
	clock.start()
	pass # Replace with function body.

func day():
	numCustomers += CUSINCRATE
	endOfDayQuota += QUOTINCRATE
	canvas_modulate.visible = false
	
func night():
	for customer in customers.get_children():
		customer.queue_free()
	canvas_modulate.visible = true
		

func _on_cust_spawn_rate_timeout():
	if (isDay):
		var newCustomer = customerPath.instantiate()
		newCustomer.position = Vector2(5, 10)
		customers.add_child(newCustomer)
		
	
	pass # Replace with function body.
