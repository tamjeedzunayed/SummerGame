extends Button
const SHOVEL_APPLIANCE = preload("res://Assets/shovel Appliance.png")
@export var applianceHeld:Appliance:
	set(value):
		#print(value)
		icon = value.icon
		applianceHeld = value
# Called when the node enters the scene tree for the first time.
func _ready():
	#applianceHeld = Appliance.new("base", 10.0, 10,SHOVEL_APPLIANCE, "ShovelHolder")
	pass # Replace with function body.
