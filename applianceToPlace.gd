extends Sprite2D

var applianceHeld:Appliance:
	set(value):
		applianceHeld = value
		texture = applianceHeld.icon

