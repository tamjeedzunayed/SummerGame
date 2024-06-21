extends StaticBody2D

const SHOVEL_APPLIANCE = preload("res://Assets/shovel Appliance.png")
#@onready var appliance_texture = %ApplianceTexture
#@onready var label = $Label
@export var appliance : Appliance = Appliance.new("appliance", 10.0, 10, SHOVEL_APPLIANCE, "ShovelHolder")
@onready var appliance_storage_bar = %ApplianceStorageBar
signal capacity_changed(new_capacity) # this will be called when the appliance.capacity gets changed
signal usedCapacity_changed(new_capacity)
# Called when the node enters the scene tree for the first time.
func _ready(): 
	#appliance_texture.texture = appliance.icon
	appliance.connect("capacity_changed", _on_capacity_changed)
	appliance.connect("usedCapacity_changed", _on_usedCapacity_changed) # connects the signal "usedCapacity_changed" to the function _on_usedCapacity_changed
	pass # Replace with function body.

func _on_capacity_changed(new_capacity):
	appliance_storage_bar.max_value = new_capacity
	pass
	
func _on_usedCapacity_changed(new_capacity):
	appliance_storage_bar.value = new_capacity
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
