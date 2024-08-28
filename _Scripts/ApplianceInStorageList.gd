extends Button

@export var appliance : Appliance :
	set(value):
		appliance = value
		icon = appliance.icon

signal selected(appliance)
# Called when the node enters the scene tree for the first time.
func _ready():
	#appliance = Appliance.new("appliance", 10.0, 10, null, "ShovelHolder")
	#icon = appliance.icon
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_pressed():
	selected.emit(appliance)
	pass # Replace with function body.
