extends CanvasLayer
@onready var panel = $Panel
@onready var animation_player = $AnimationPlayer
@onready var button = $Button
@export var itsDay = false
@export var inView = false
@onready var supply_connections = $"Panel/TabContainer/Supply Connections"
var storageCapacity :
	get:
		return supply_connections.storageCapacity

var storageCapacityUsed :
	get: 
		return supply_connections.storageCapacityUsed

signal ItemsBought(items)


func _ready():
	supply_connections.connect("StorageFull", storageFull)

func day():
	button.disabled = true
	if (inView):
		animation_player.play("TransOut")
		inView = false

func night():
	button.disabled = false

func storageFull():
	if animation_player.is_playing():
		animation_player.stop()
	animation_player.play("StorageFull")

func _on_button_pressed():
	if(inView):
		animation_player.play("TransOut")
		inView = false
	else:
		animation_player.play("TransIn")
		inView = true

