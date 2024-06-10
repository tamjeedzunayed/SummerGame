extends CharacterBody2D

@onready var navigation_agent = $NavigationAgent2D
@onready var animated_sprite = $AnimatedSprite2D
var shopingList: Array[Item] = [Item.new("Shovel", 10.0, 10.0, 10.0, null, "ShovelHolder")]
var heldItems: Array[Item] = []
const SPEED : float = 130.0
var currentItemTarget : Item
var currentApplianceTarget

signal findAppliance(item: Item, customer : CharacterBody2D)

func _ready():
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
	print("going home")
	
	navigation_agent.target_position = Vector2(200, 200)

func getItemFromAppliance(appliance):
	currentApplianceTarget = appliance
	navigation_agent.target_position = appliance.position
	

func _on_navigation_agent_2d_navigation_finished():
	if currentItemTarget != null:
		var itemFromAppliance = currentApplianceTarget.appliance.retrieveItem(currentItemTarget)  
		if itemFromAppliance != null:
			heldItems.append(itemFromAppliance)
		goThroughShopingList()
	pass # Replace with function body.
