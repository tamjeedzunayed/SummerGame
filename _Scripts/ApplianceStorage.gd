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
		if ApplianceButtonGroup.get_pressed_button() == null:
			return null
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
	newApplianceInStorageList.appliance.connect("update", setApplianceInfo) #FIXME
	newApplianceInStorageList.connect("selected", setNewAppliance)
	appliance_list.add_child(newApplianceInStorageList)
	setNewAppliance(applianceSelected)

func setNewAppliance(appliance : Appliance):
	for child in items_in_appliance.get_children():
		child.queue_free()
	setApplianceInfo(appliance)

func setApplianceInfo(appliance : Appliance):
	if appliance != applianceSelected: return
	capacity_label.text = "Appliance Capacity: " + str( applianceSelected.capacity)
	used_capacity_label.text = "Used Capacity: " + str( applianceSelected.usedCapacity)
	type_label.text = "Appliance Type: " + applianceSelected.type
	appliance_icon.texture = applianceSelected.icon
	for item in applianceSelected.storage.keys():
		var added = false
		for child in items_in_appliance.get_children():
			if child.itemHeld.name == item.name && child.itemHeld.sellPrice == item.sellPrice:
				child.amount = applianceSelected.storage[item]
				if child.amount == 0:
					child.queue_free()
				added = true
				break
		if applianceSelected.storage[item] == 0:
			continue
		if added: continue
		var newButton = itemInStorageButton.instantiate()
		newButton.dragItemAmount = drag_amount.value 
		items_in_appliance.add_child(newButton)
		newButton.itemHeld = item
		newButton.amount = applianceSelected.storage[item]
		newButton.connect("updateAmount", updateApplianceStorage)

func updateApplianceStorage(itemChanged, newAmount):
	for item in applianceSelected.storage.keys():
		if (item.name == itemChanged.name) && (item.sellPrice == itemChanged.sellPrice):
			used_capacity_label.text = "Used Capacity: " + str(applianceSelected.usedCapacity + newAmount - applianceSelected.storage[item])
			applianceSelected.usedCapacity += newAmount - applianceSelected.storage[item]
			applianceSelected.storage[item] = newAmount
			return

func _on_trash_body_entered(body):
	body.trashed = true
	pass # Replace with function body.

func _on_trash_body_exited(body):
	body.trashed = false
	pass # Replace with function body.

func _on_collect_region_body_entered(body):
	if applianceSelected == null: return
	body.appliancePlacedInto = applianceSelected
	pass # Replace with function body.

func _on_collect_region_body_exited(body):
	body.appliancePlacedInto = null
	pass # Replace with function body.

func _on_appliance_storage_button_pressed():
	if (!appliance_storage_in_display):
		animation_player.play("Panel_In")
		appliance_storage_in_display = true
	else:
		animation_player.play("Panel_Out")
		appliance_storage_in_display = false
	pass # Replace with function body.
	pass # Replace with function body.


func _on_drag_amount_value_changed(value):
	drag_amount.value = value
	var dragAmount = value
	for iteminlist in items_in_appliance.get_children():
		iteminlist.dragItemAmount = dragAmount 
	pass # Replace with function body.
