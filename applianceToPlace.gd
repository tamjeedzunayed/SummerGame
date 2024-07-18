extends Sprite2D

var applianceHeld:Appliance:
	set(value):
		applianceHeld = value
		texture = applianceHeld.icon



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
