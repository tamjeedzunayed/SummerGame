extends Button


@export var itemHeld : Item 
@onready var item_information = $"../../../VBoxContainer/Item Information"

# Called when the node enters the scene tree for the first time.
func _ready():
	icon = itemHeld.icon
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_toggled(toggled_on):
	if toggled_on:
		item_information.text = "Tool

Price: " + str(itemHeld.price) + "
Sell Value:" + str(itemHeld.sellPrice) +"
Exp:" + str(itemHeld.expe) + "

Total:"
