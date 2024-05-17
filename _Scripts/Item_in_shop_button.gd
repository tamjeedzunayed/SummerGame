extends Button

@onready var label = $Label
@export var itemHeld : Item 

var amount := 0:
	set(value):
		amount = value
		label.text = str(amount) + "/10"
# Called when the node enters the scene tree for the first time.
func _ready():
	icon = itemHeld.icon
	pass # Replace with function body.
