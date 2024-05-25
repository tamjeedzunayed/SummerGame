extends CanvasLayer
@onready var panel = $Panel
@onready var animation_player = $AnimationPlayer
@onready var button = $Button
@export var itsDay = false
@export var inView = false
@onready var supply_connections = $"Panel/TabContainer/Supply Connections"

signal ItemsBought(items)

func _ready():
	supply_connections.connect("ItemsBought", itemsBought)
	supply_connections.connect("StorageFull", storageFull)

func storageFull():
	if animation_player.is_playing():
		animation_player.stop()
	animation_player.play("StorageFull")

func itemsBought(items):
	ItemsBought.emit(items)

func _on_button_pressed():
	if(inView):
		animation_player.play("TransOut")
		inView = false
	else:
		animation_player.play("TransIn")
		inView = true
	pass # Replace with function body.

