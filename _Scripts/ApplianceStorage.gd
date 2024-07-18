extends Panel
@onready var type_label = %TypeLabel 
@onready var appliance_icon = %ApplianceIcon
@onready var capacity_label = %CapacityLabel
@onready var used_capacity_label = %UsedCapacityLabel
@onready var appliance_list = %"Appliance List"
@onready var items_in_appliance = %ItemsInAppliance
@onready var drag_amount = %DragAmount

const applianceInStorageList = preload("res://Scenes/appliance_in_storage_list.tscn")
const itemInStorageButton = preload("res://Scenes/Item_Dragging/Item_in_truck_storage.tscn")
var appliance_storage_in_display = false
@onready var animation_player = $AnimationPlayer
var ApplianceButtonGroup := ButtonGroup.new()
var applianceSelected:Appliance:
	get:
		return ApplianceButtonGroup.get_pressed_button().appliance
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func addAppliance(newAppliance):
	var newApplianceInStorageList = applianceInStorageList.instantiate()
	newApplianceInStorageList.button_group = ApplianceButtonGroup
	newApplianceInStorageList.button_pressed = true
	newApplianceInStorageList.appliance = newAppliance.appliance
	newApplianceInStorageList.appliance.connect("update", setApplianceInfo)
	newApplianceInStorageList.connect("pressed", setApplianceInfo)
	appliance_list.add_child(newApplianceInStorageList)
	setApplianceInfo()

func setApplianceInfo():
	capacity_label.text = "Appliance Capacity: " + str( applianceSelected.capacity)
	used_capacity_label.text = "Used Capacity: " + str( applianceSelected.usedCapacity)
	type_label.text = "Appliance Type: " + applianceSelected.type
	appliance_icon.texture = applianceSelected.icon
	for child in items_in_appliance.get_children():
		child.queue_free()
	for item in applianceSelected.storage.keys():
		var newButton = itemInStorageButton.instantiate()
		newButton.itemHeld = item
		newButton.dragItemAmount = drag_amount.value 
		items_in_appliance.add_child(newButton)
		newButton.amount = applianceSelected.storage[item]

func _on_truck_storage_button_pressed():
	if (!appliance_storage_in_display):
		animation_player.play("Panel_In")
		appliance_storage_in_display = true
	else:
		animation_player.play("Panel_Out")
		appliance_storage_in_display = false
	pass # Replace with function body.
	
func _on_trash_body_entered(body):
	body.trashed = true
	pass # Replace with function body.

func _on_trash_body_exited(body):
	body.trashed = false
	pass # Replace with function body.

func _on_collect_region_body_entered(body):
	body.appliancePlacedInto = applianceSelected
	pass # Replace with function body.

func _on_collect_region_body_exited(body):
	body.appliancePlacedInto = null
	pass # Replace with function body.
