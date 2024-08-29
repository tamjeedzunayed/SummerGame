extends Panel
@onready var daily_income_container = $MarginContainer/HBoxContainer/VBoxContainer/Panel2/ScrollContainer/MarginContainer/DailyIncomeContainer
const DAILYLABELSCENE = preload("res://Scenes/Finances/dailyIncome.tscn")
var dailyIncome = null
var dailyButtonGroup = ButtonGroup.new()
@onready var details = $MarginContainer/HBoxContainer/ExpensesDisplay/Details

const SPECIFIC_TRANSACTION = preload("res://Scenes/Finances/specific_transaction.tscn")
const TYPE_TRANSACTION = preload("res://Scenes/Finances/type_transaction.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func instantiateDailyIncome(dayNum):
	dailyIncome = DAILYLABELSCENE.instantiate()
	daily_income_container.add_child(dailyIncome)
	dailyIncome.connect("gotPressed", setDailyInfo)
	dailyIncome.setDayNum(dayNum)
	dailyIncome.total = 0
	


func setDailyInfo(buttonPressed):
	for child in details.get_children():
		child.queue_free()
	makeTypeSection(buttonPressed.Sales, "Sales")	
	makeTypeSection(buttonPressed.Purchases, "Purchases")
	makeTypeSection(buttonPressed.Upgrades, "Upgrades")
	makeTypeSection(buttonPressed.Expenses, "Expenses")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func makeTypeSection(typeSection, typeName : String):
	var type : Dictionary = typeSection
	var total = 0
	var type_transaction = TYPE_TRANSACTION.instantiate()
	if (!type.is_empty()):
		for key in type.keys():
			total += type[key]
	type_transaction.get_child(1).text = typeName
	type_transaction.get_child(2).text = str(total)
	details.add_child(type_transaction)
	if (!type.is_empty()):
		for key in type.keys():
			var transactionView = SPECIFIC_TRANSACTION.instantiate()
			transactionView.get_child(1).text = key
			transactionView.get_child(2).text = str(type[key])
			details.add_child(transactionView)
	
