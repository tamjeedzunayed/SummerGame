extends Button
class_name Seller

@onready var texture_rect = $TextureRect
@export var items: Array[Item]
@export var cred: int = 90
@onready var big_seller_pic_display = %BigSellerPicDisplay
@onready var cred_bar = %CredBar

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _init(ItemsList):
	items = ItemsList


func _on_pressed():
	cred_bar.value = cred
	big_seller_pic_display.texture = get_child(0).icon
	pass # Replace with function body.
