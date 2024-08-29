extends Button
@onready var day_ = $"MarginContainer/DailyIncome/Day#"
@onready var money_made = $MarginContainer/DailyIncome/MoneyMade
signal gotPressed(buttonPressed)
var total = 0 : 
	set(value): 
		if (value >= 0):
			money_made.add_theme_color_override("font_color", Color(0,255,0))
			money_made.text = "+" + str(value)
		else:
			money_made.add_theme_color_override("font_color", Color(255,0,0))
			money_made.text = str(value)
			total = value
		emit_signal("gotPressed", self)
\
var Sales  		= {}
var Purchases 	= {}
var Upgrades 	= {}
var Expenses	= {}         

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func setDayNum(dayNum):
	day_.text = "Day " + str(dayNum)
	
func updateDailyIncome(type : String, specific : String, amount : float):
	total += amount
	if (type == "Sales"):
		if (Sales.has(specific)):
			Sales[specific] += amount
		else:
			Sales[specific] = amount
	elif (type == "Purchases"):	
		if (Purchases.has(specific)):
			Purchases[specific] += amount
		else:
			Purchases[specific] = amount
	elif (type == "Upgrades"):	
		if (Upgrades.has(specific)):
			Upgrades[specific] += amount
		else:
			Upgrades[specific] = amount
	elif (type == "Expenses"):	
		if (Expenses.has(specific)):
			Expenses[specific] += amount
		else:
			Expenses[specific] = amount
	else: 
		print("Not Valid Transaction")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	emit_signal("gotPressed", self)
	pass # Replace with function body.
