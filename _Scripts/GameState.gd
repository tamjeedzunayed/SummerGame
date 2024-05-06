extends Node


@onready var furnitures = $Furnitures
@onready var customers = %Customers
@onready var cust_spawn_rate = $CustSpawnRate

@onready var clock = $Timer
@onready var clockButton = $PanelContainer/MarginContainer/GridContainer/Button

@onready var canvas_modulate : CanvasModulate = $CanvasModulate
@onready var animation_player : AnimationPlayer = canvas_modulate.get_child(0)
@onready var ground_tile_map : TileMap = $GroundTileMap


const CUSTSPAWNRATE = 5
const CUSINCRATE = 1
const QUOTINCRATE = 100
@export var DAY_TIME_LENGTH : float = 12.

var isDay:bool = true
var numCustomers = 0
var rating = 5
var endOfDayQuota = 0

var customerResource = preload("res://Scenes/customer.tscn")
var furnitureResource = preload("res://Scenes/furniture.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	cust_spawn_rate.wait_time = CUSTSPAWNRATE
	clock.wait_time = DAY_TIME_LENGTH
	clock.start()
	animation_player.speed_scale = 1./DAY_TIME_LENGTH
	animation_player.play("Day animation")
	
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
	
	if (isDay):
		clock.wait_time = DAY_TIME_LENGTH
		day()
	else:
		clock.wait_time = DAY_TIME_LENGTH/3.
		night()
	clock.start()
	pass # Replace with function body.

func day():
	numCustomers += CUSINCRATE
	endOfDayQuota += QUOTINCRATE
	animation_player.play("Day animation")
	
func night():
	for customer in customers.get_children():
		customer.queue_free()
	#canvas_modulate.visible = true
		

func _on_cust_spawn_rate_timeout():
	if (isDay):
		var newCustomer = customerResource.instantiate()
		newCustomer.position = Vector2(5, 10)
		customers.add_child(newCustomer)
		
	
	pass # Replace with function body.

func _input(_event):
	if Input.is_action_just_pressed("LMB"):
		var click_pos_on_map = ground_tile_map.local_to_map(get_window().get_mouse_position())
		
		if	ground_tile_map.get_cell_tile_data(1, click_pos_on_map - Vector2i(18, 10)) != null:
			return
		
		var furniture : Node2D= furnitureResource.instantiate()
		furniture.position = ground_tile_map.map_to_local(click_pos_on_map)
		print(furniture.position.y)
		furnitures.add_child(furniture) 
		
		ground_tile_map.set_cell(1, click_pos_on_map - Vector2i(18, 10), 1, ground_tile_map.get_cell_atlas_coords(0, click_pos_on_map - Vector2i(18, 10)))
		ground_tile_map.erase_cell(0, click_pos_on_map - Vector2i(18, 10))
