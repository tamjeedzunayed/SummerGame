extends CharacterBody2D

@onready var navigation_agent = $NavigationAgent2D
@onready var animated_sprite = $AnimatedSprite2D
var shopingList: Array[Item] = [Item.new("Shovel", 10.0, 10.0, 10.0, null, "ShovelHolder")]
var heldItems: Array[Item] = []
const SPEED : float = 130.0
var currentItemTarget : Item
var currentApplianceTarget
const itemInShoppingList = preload("res://Scenes/Item_in_ShoppingList.tscn")
@onready var shopping_list = %ShoppingList
var checkBoxIndex = 0
var numItemsInShoppingList = 0
signal findAppliance(item: Item, customer : CharacterBody2D)

func _ready():
	createCheckBoxes()
	goThroughShopingList()

func _physics_process(_delta):
	var dir : Vector2
	if !navigation_agent.is_navigation_finished():
		dir = to_local(navigation_agent.get_next_path_position()).normalized()
	else:
		dir = Vector2.ZERO
	
	
	if (dir.dot(Vector2.UP) > 0.7):
		animated_sprite.play("up")
	elif (dir.dot(Vector2.RIGHT) > 0.5):
		animated_sprite.play("left")
		animated_sprite.flip_h = true
	elif (dir.dot(Vector2.LEFT) > 0.5):
		animated_sprite.play("left")
		animated_sprite.flip_h = false
	else:
		animated_sprite.play("down")
		
	velocity = lerp(velocity, dir * SPEED, 0.1);
	
	move_and_slide()

func _input(_event):
	if Input.is_action_just_pressed("RMB"):
		navigation_agent.target_position = get_global_mouse_position()
		
func goThroughShopingList():
	if shopingList.is_empty():
		goHome()
		return
	
	currentItemTarget = shopingList.pop_front()
	findAppliance.emit(currentItemTarget, self)

func goHome():
	navigation_agent.target_position = Vector2(200, 200)

func getItemFromAppliance(appliance):
	currentApplianceTarget = appliance
	navigation_agent.target_position = appliance.position
	

func _on_navigation_agent_2d_navigation_finished():
	if currentItemTarget != null && currentApplianceTarget != null:
		var itemFromAppliance = currentApplianceTarget.appliance.retrieveItem(currentItemTarget)  
		if itemFromAppliance != null:
			heldItems.append(itemFromAppliance)
		if(checkBoxIndex < numItemsInShoppingList):	
			var checkBox : CheckBox = shopping_list.get_child(checkBoxIndex)
			checkBox.button_pressed = true
			checkBoxIndex += 1
		goThroughShopingList()
	pass # Replace with function body.

func createCheckBoxes():
	for item in shopingList:
		var shopingListItem = itemInShoppingList.instantiate()
		shopping_list.add_child(shopingListItem)
		shopingListItem.text = item.name
		numItemsInShoppingList += 1
	pass
