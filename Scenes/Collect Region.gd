extends Area2D
var applianceOnDisplay : Appliance = Appliance.new("appliance", 10.0, 10, null, "ShovelHolder")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	print("want to store")
	if (body.itemHeld.applianceType == applianceOnDisplay.type && 
	applianceOnDisplay.usedCapacity + body.numItems <= applianceOnDisplay.capacity):
		applianceOnDisplay.addItem(body.itemHeld, body.numItems)
		body.TruckStorageParent.trashItem()
	pass # Replace with function body.
