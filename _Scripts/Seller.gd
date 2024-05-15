extends Button

@onready var texture_rect = $TextureRect
@export var items : Array[Item]
@export var level : int = 1
@export var cred: int = 20
@export var discountUpgrade : int = 0
@export var itemQualityUpgrade : int = 0
@export var cartUpgrade : int = 0
@export var expPoints : int = 0

signal seller_pressed(SellerInfo)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
#func _init(ItemsList):
	#items = ItemsList

func _on_pressed():
	seller_pressed.emit({"items": items, 
						"cred":cred, 
						"cartUpgrade":cartUpgrade, 
						"discountUpgrade":discountUpgrade,
						"itemQualityUpgrade":itemQualityUpgrade,
						"level":level,
						"expPoints":expPoints,
						"icon":icon})
	pass # Replace with function body.
