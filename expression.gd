class_name ExpressionContainer
extends NumberContainer

var answer: NumberTile
@onready var number_tile: PackedScene = load("res://number_tile.tscn")

var parser := Expression.new()

func _ready() -> void:
	pass

func delete_previous_answer():
	$"../../Answer/Symbols".children.clear()
	$"../../Answer/Symbols".length = 0
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
	for child in children:
		child.queue_free()
	children.clear()
	length = 0
	answer = null

func create_expression() -> String:
	var components: Array[String] = []
	for child in children:
		if child.type == Root.Tiles.SHADOW:
			continue
		components.append(child.get_child(2).text)
	
	var expression = " ".join(components)
	expression = expression.replace("×","*")
	expression = expression.replace("÷","/")
	
	return expression

func create_history() -> Array:
	var history: Array = []
	for child in children:
		if child.type == Root.Tiles.SHADOW:
			continue
		if child.type == Root.Tiles.NUMBER:
			if child.history:
				history.append(child.history)
				continue
		history.append(child.get_child(2).text)
	
	return history

func validate_expression(expression) -> bool:
	var error = parser.parse(expression)
	if error != OK:
		print(parser.get_error_text())
		return false
	
	var result = parser.execute()
	if parser.has_execute_failed() or round(result) != result:
		return false
	
	return true

func calcuate_answer() -> int:
	return int(parser.execute())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	super._process(_delta)
	var num_components = length
	for child in children:
		if child.type == Root.Tiles.SHADOW:
			num_components -= 1

	
	var expression = create_expression()
	var history = create_history()
	
	if num_components > 1 and validate_expression(expression):
		var output = calcuate_answer()
		if answer:
			if answer.number == output:
				return
			delete_previous_answer()
		answer = create_answer(output,expression,history)
	else:
		if answer:
			delete_previous_answer()
