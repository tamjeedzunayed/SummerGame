extends TextureRect

@onready var num_items = $numItems
@export var itemHeld : Item :
	set(value):
		itemHeld = value
		texture = value.icon

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
