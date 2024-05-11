extends CanvasLayer
@onready var panel = $Panel
@onready var animation_player = $AnimationPlayer
@onready var button = $Button
@export var itsDay = false
@export var inView = false

# Called when the node enters the scene tree for the first time.
func _ready():
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_pressed():
	if(inView):
		animation_player.play("TransOut")
		inView = false
	else:
		animation_player.play("TransIn")
		inView = true

		
	pass # Replace with function body.

func set_Shop_for_connect(guy):
	var label = $"Panel/TabContainer/Supply Connections/Supply Connections/GridContainer/Items On Sale/MarginContainer/HBoxContainer/VBoxContainer/Label"
	
	label.text = guy.text + "
	
Reputation Level:"
	pass

func _on_guy_pressed():
	var guy = $"Panel/TabContainer/Supply Connections/Supply Connections/GridContainer/ScrollContainer/VBoxContainer/Guy"
	set_Shop_for_connect(guy)
	
	pass # Replace with function body.

	
func _on_guy_2_pressed():
	var guy_2 = $"Panel/TabContainer/Supply Connections/Supply Connections/GridContainer/ScrollContainer/VBoxContainer/Guy2"

	set_Shop_for_connect(guy_2)
	pass # Replace with function body.


func _on_guy_3_pressed():
	var guy_3 = $"Panel/TabContainer/Supply Connections/Supply Connections/GridContainer/ScrollContainer/VBoxContainer/Guy3"
	set_Shop_for_connect(guy_3)
	pass # Replace with function body.


func _on_guy_4_pressed():
	var guy_4 = $"Panel/TabContainer/Supply Connections/Supply Connections/GridContainer/ScrollContainer/VBoxContainer/Guy4"
	set_Shop_for_connect(guy_4)
	pass # Replace with function body.


func _on_guy_5_pressed():
	var guy_5 = $"Panel/TabContainer/Supply Connections/Supply Connections/GridContainer/ScrollContainer/VBoxContainer/Guy5"
	set_Shop_for_connect(guy_5)
	pass # Replace with function body.



func _on_guy_6_pressed():
	var guy_6 = $"Panel/TabContainer/Supply Connections/Supply Connections/GridContainer/ScrollContainer/VBoxContainer/Guy6"
	set_Shop_for_connect(guy_6)
	pass # Replace with function body.
