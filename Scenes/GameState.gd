extends Node

@onready var game_state = $"."
@onready var label = $PanelContainer/GridContainer/Label

@onready var customers = %Customers
@onready var cust_spawn_rate = $CustSpawnRate

@onready var clock = $Timer
@onready var clockButton = $PanelContainer/MarginContainer/GridContainer/Button


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
	var secs = fmod(clock.time_left,60)
	var mins = fmod(clock.time_left, 60*60) / 60
	var time_passed = "%02d : %02d" % [mins,secs]
	clockButton.text  = time_passed
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
