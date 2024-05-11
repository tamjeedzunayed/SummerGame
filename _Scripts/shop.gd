extends CanvasLayer
@onready var panel = $Panel
@onready var animation_player = $AnimationPlayer
@onready var button = $Button
@export var itsDay = false
@export var inView = false

@onready var seller = $"Panel/TabContainer/Supply Connections/Supply Connections/GridContainer/ScrollContainer/VBoxContainer/Seller"
const SHOVEL = preload("res://Assets/Shovel.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	var shovel = Item.new(10,10,10, SHOVEL)
	var shovel2 = Item.new(10,12,10, SHOVEL)
	seller.items.append(shovel)
	seller.items.append(shovel2)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_button_pressed():
	if(inView):
		animation_player.play("TransOut")
		inView = false
	else:
		animation_player.play("TransIn")
		inView = true
	pass # Replace with function body.



