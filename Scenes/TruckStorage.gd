extends Panel

@onready var truck_storage_button = $"Truck Storage Button"
@onready var animation_player = $AnimationPlayer
var truck_storage_in_display = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_truck_storage_button_pressed():
	if (truck_storage_in_display):
		animation_player.play("TruckStorage_in")
		truck_storage_in_display = true
	else:
		animation_player.play("TruckStorage_out")
		truck_storage_in_display = false
	pass # Replace with function body.
