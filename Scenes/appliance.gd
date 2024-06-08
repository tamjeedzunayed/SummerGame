extends TextureButton

@onready var label = $Label
@export var appliance : Appliance 
@onready var appliance_storage_bar = %ApplianceStorageBar
signal capacity_changed(new_capacity) # this will be called when the appliance.capacity gets changed

# Called when the node enters the scene tree for the first time.
func _ready():
	texture_normal = appliance.icon
	texture_pressed = appliance.icon
	texture_hover = appliance.icon
	texture_disabled = appliance.icon
	texture_focused = appliance.icon
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
