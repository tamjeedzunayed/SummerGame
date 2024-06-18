extends Panel

@onready var appliance_list = %"Appliance List"
const applianceInStorageList = preload("res://Scenes/appliance_in_storage_list.tscn")
var appliance_storage_in_display = false
@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func addAppliance(newAppliance):
	var newApplianceInStorageList = applianceInStorageList.instantiate()
	newApplianceInStorageList.appliance = newAppliance.appliance
	appliance_list.add_child(newApplianceInStorageList)

func _on_truck_storage_button_pressed():
	if (!appliance_storage_in_display):
		animation_player.play("Panel_In")
		appliance_storage_in_display = true
	else:
		animation_player.play("Panel_Out")
		appliance_storage_in_display = false
	pass # Replace with function body.
	

#func _on_appliances_child_exiting_tree(node):
#	for app in appliance_list:
#		if node.appliance == app.appliance:
#			appliance_list.remove_child(app)
#	pass # Replace with function body.
