extends Control
@onready var truck_storage_button = $"Truck Storage Button"

@onready var animation_player = $AnimationPlayer
var truck_storage_in_display = false
@onready var truck_item_list = %TruckItemList

const ITEM_IN_SHOP_BUTTON = preload("res://Scenes/Item_in_shop_button.tscn")
# Called when the node enters the scene tree for the first time.

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hello(storage):
	print("hello")
	for child in truck_item_list.get_children():
		child.queue_free()
	for item in storage.keys():
		var newButton = ITEM_IN_SHOP_BUTTON.instantiate()
		newButton.itemHeld = item 
		truck_item_list.add_child(newButton)

func _on_truck_storage_button_pressed():
	if (!truck_storage_in_display):
		animation_player.play("Panel_In")
		truck_storage_in_display = true
	else:
		animation_player.play("Panel_Out")
		truck_storage_in_display = false
	pass # Replace with function body.
