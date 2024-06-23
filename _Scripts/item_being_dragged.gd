extends CharacterBody2D

@onready var item_image = $ItemImage
@onready var num_items = $numItems
var TruckStorageParent
var numItems: 
	set(value):
		numItems = value
		num_items.text = str(value)
@export var itemHeld : Item :
	set(value):
		itemHeld = value
		

# Called when the node enters the scene tree for the first time.
func _ready():
	item_image.texture = itemHeld.icon
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

