extends Button

@onready var label = $Label
@export var itemHeld : Item = Item.new("Shovel", 5,7,7, preload("res://Assets/Shovel.png"), "ShovelHolder") :
	set(value):
		itemHeld = value
		icon = itemHeld.icon
var limit : int
const DRAGGINGITEM = preload("res://Scenes/Item_Dragging/item_being_dragged.tscn")
var of = Vector2(0,0)
var draggingItem : TextureRect = null
var dragItemAmount = 0
var dragging = false :
	set(value):
		if value && amount >= dragItemAmount:
			dragging = value
			draggingItem = DRAGGINGITEM.instantiate()
			draggingItem.position = position
			draggingItem.itemHeld = itemHeld
			draggingItem.num_items = dragItemAmount
			add_child(draggingItem)
		elif draggingItem:
			remove_child(draggingItem)
			draggingItem = null
			
var amount := 0 :
	set(value):
		amount = value
		label.text = str(amount)
		if (limit != -1):
			label.text = label.text + "/" + str(limit)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _process(_delta):
	if dragging && draggingItem:
		draggingItem.global_position = get_global_mouse_position() - of
	pass


func _on_button_down():
	dragging = true
	of = get_global_mouse_position() - global_position
	pass # Replace with function body.


func _on_button_up():
	dragging = false
	pass # Replace with function body.


	
