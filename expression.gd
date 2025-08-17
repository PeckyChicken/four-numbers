class_name ExpressionContainer
extends NumberContainer

var operation_array = ["+","-","×","÷","(",")","*","/"]

var answer: NumberTile
@onready var number_tile: PackedScene = load("res://number_tile.tscn")

var parser := Expression.new()

func _ready() -> void:
	pass

func delete_previous_answer():
	answer.queue_free()
	answer = null

func create_answer(output: int, expression: String, history:Array) -> NumberTile:
	var tile: NumberTile = number_tile.instantiate()
	tile.number = output
	tile.expression = expression
	tile.history = history
	tile.type = Root.Tiles.ANSWER
	tile.draggable = true
	tile.extra_data["expression"] = self
	add_sibling(tile)
	tile.add_to_container($"../../Answer/Symbols")
	
	return tile

func clear():
	for child in get_children():
		child.queue_free()
	get_children().clear()
	answer = null

func create_expression() -> String:
	var components: Array[String] = []
	for child in get_children():
		if child.type == Root.Tiles.SHADOW:
			continue
		if child.type == Root.Tiles.NUMBER:
			components.append(str(child.number))
		elif child.type == Root.Tiles.OPERATION:
			components.append(child.operation)
	
	var expression = " ".join(components)
	
	return expression

func godotify_expression(expression: String) -> String:
	var components = expression.split(" ")
	var index = 0
	for component in components:
		if component.is_valid_int():
			components[index] = str(float(component))
		index += 1
	expression = " ".join(components)
	
	expression = expression.replace("×","*")
	expression = expression.replace("÷","/")
	return expression

func create_history() -> Array:
	var history: Array = []
	for child in get_children():
		if child.type == Root.Tiles.SHADOW:
			continue
		if child.type == Root.Tiles.NUMBER:
			if child.history:
				history.append(child.history)
				continue
		history.append(child.get_child(2).text)
	
	return history

func remove_ops(expression: String) -> String:
	for op in operation_array:
		expression = expression.replace(" "+op,"")
	return expression

func check_operators(expression: String) -> bool:
	var components: PackedStringArray = expression.split(" ")
	if len(components) < 2:
		return true
	var index = 0
	for component in components:
		if component in operation_array:
			#print("Component %s is in operation array, running checks." % [component])
			#print("DEBUG DATA: components: %s index: %s operation_array: %s" % [components,index,operation_array])
			if component in "()":
				#print("Component is a bracket, ignoring")
				index += 1
				continue
			if index == 0 or index == len(components)-1:
				#print("Operation found at start, invalid.")
				return true
			elif components[index-1] in ["+","-","×","÷","(","*","/"] or components[index+1] in ["+","-","×","÷",")","*","/"]:
				#print("Previous or next component is also operation, invalid")
				return true
			#print("No issues were found with component, continuing")
		index += 1
	return false

func check_repeating_numbers(expression: String) -> bool:
	var components: PackedStringArray = expression.replace(" (","").replace(" )","").split(" ")
	if len(components) < 2:
		return true
	var index = 0
	for component in components:
		if component.is_valid_float():
			if index != 0 and components[index-1].is_valid_float():
				
				return true
		index += 1
	return false

func validate_expression(expression: String) -> bool:
	var error = parser.parse(expression)
	if error != OK:
		return false
	
	var result = parser.execute()
	if parser.has_execute_failed():
		print(parser.get_error_text())
		return false
	if round(result) != result:
		print("Answer was not whole")
		return false
	
	if expression.count("(") != expression.count(")"):
		return false
	
	if not ["+","-","×","÷","*","/"].any(func(x):return x in expression):
		return false
	
	if check_repeating_numbers(expression):
		return false
	
	if check_operators(expression):
		return false
	
	return true

func calcuate_answer() -> int:
	return int(parser.execute())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	super._process(_delta)
	var num_components = length()
	for child in get_children():
		if child.type == Root.Tiles.SHADOW:
			num_components -= 1

	
	var expression = create_expression()
	var history = create_history()
	if num_components > 1 and validate_expression(godotify_expression(expression)):
		var output = calcuate_answer()
		if answer:
			if answer.number == output and answer.expression == expression:
				return
			delete_previous_answer()
		answer = create_answer(output,expression,history)
	else:
		if answer:
			delete_previous_answer()
