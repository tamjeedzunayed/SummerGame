extends Button

@onready var label = $Label
@export var itemHeld : Item 
var limit : int

var amount := 0 :
	set(value):
		amount = value
		label.text = str(amount)
		if (limit != -1):
			label.text = label.text + "/" + str(limit)
# Called when the node enters the scene tree for the first time.
func _ready():
	icon = itemHeld.icon
	pass # Replace with function body.
