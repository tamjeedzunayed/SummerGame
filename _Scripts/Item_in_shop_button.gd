extends Button

@onready var item_image = $"Item Image"
@onready var label = $Label
@export var itemHeld : Item = Item.new("Shovel", 5,7,7, preload("res://Assets/Shovel.png"), "ShovelHolder") :
	set(value):
		itemHeld = value
		item_image.texture = itemHeld.icon
const DRAGGINGITEM = preload("res://Scenes/Item_Dragging/item_being_dragged.tscn")
var of = Vector2(0,0)

var draggingItem : CharacterBody2D = null
var dragItemAmount = 1
var dragging = false :
	set(value):
		if value && (amount >= dragItemAmount):
			dragging = value
			draggingItem = DRAGGINGITEM.instantiate()
			draggingItem.TruckStorageParent = self
			draggingItem.position = position
			draggingItem.itemHeld = itemHeld
			add_child(draggingItem)
			draggingItem.numItems = dragItemAmount
			amount = amount - dragItemAmount
		elif draggingItem:
			if draggingItem.appliancePlacedInto != null:
				if (draggingItem.itemHeld.applianceType == draggingItem.appliancePlacedInto.type && 
				draggingItem.appliancePlacedInto.usedCapacity + draggingItem.numItems <= draggingItem.appliancePlacedInto.capacity):
					draggingItem.appliancePlacedInto.addItem(draggingItem.itemHeld, draggingItem.numItems)
					draggingItem.TruckStorageParent.trashItem()
				else:
					remove_child(draggingItem)
					amount = amount + draggingItem.numItems
			elif draggingItem.trashed == true:
				amount = amount - draggingItem.numItems
				draggingItem.TruckStorageParent.trashItem()
			else:
				amount = amount + draggingItem.numItems
				remove_child(draggingItem)
			draggingItem = null
			
var amount := 10 :
	set(value):
		amount = value
		label.text = str(amount)
		updateAmount.emit(itemHeld, amount)

signal updateAmount(itemHeld, amount)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _process(_delta):
	if dragging && draggingItem:
		draggingItem.global_position = get_global_mouse_position() - of
	pass

func _on_button_down():
	dragging = true
	of = get_global_mouse_position() - global_position - Vector2(25,25)
	button_pressed = true
	emit_signal("toggled", true)
	pass # Replace with function body.

func _on_button_up():
	dragging = false
	pass # Replace with function body.

func trashItem():
	draggingItem.animation_player.play("Place")
	if amount == 0:
		queue_free()
	

func storeItem():
	pass
