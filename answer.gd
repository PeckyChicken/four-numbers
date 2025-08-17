class_name AnswerContainer
extends NumberContainer

@onready var number_tile: PackedScene = load("res://number_tile.tscn")
@onready var operation_tile: PackedScene = load("res://operation_tile.tscn")

func compress_history_component(component) -> Array:
	var history: Array = []
	for item in component:
		if item is String:
			history.append(item)
			continue
		
		item = compress_history_component(item)
		
		var parser := Expression.new()
		assert (parser.parse(ExpressionContainer.new().godotify_expression(" ".join(item))) == OK, "Error parsing history component %s" % [component])
		
		history.append(int(parser.execute()))
	
	return history
	
func recreate_expression():
	var child: NumberTile
	for children in get_children():
		if children is NumberTile:
			child = children
			break
	assert (child.history, "Tile was passed into answer with no history. This signifies a serious problem with the \"find_overlap()\" function in tile.gd")
	var expression_container: ExpressionContainer = child.extra_data["expression"] as ExpressionContainer
	#expression_container.clear()
	
	var expression = child.expression.split(" ")
	var history = child.history
	
	expression.reverse()
	history.reverse()
	
	assert (len(history) == len(expression),"Expression %s and history %s are not the same length. Good luck debugging this, I don't know why this happened." % [expression, history])
	
	for index in range(len(expression)):
		var e_component = expression[index]
		var h_component = history[index]
		
		var new_tile: Tile
		
		if e_component.is_valid_int():
			new_tile = number_tile.instantiate() as NumberTile
			new_tile.number = int(e_component)
			new_tile.type = Root.Tiles.NUMBER
			if typeof(h_component) != typeof(e_component):
				new_tile.extra_data["expression"] = expression_container
				new_tile.expression = " ".join(compress_history_component(h_component))
		else:
			new_tile = operation_tile.instantiate() as OperationTile
			new_tile.operation = e_component
			new_tile.type = Root.Tiles.OPERATION
		
		new_tile.draggable = true
		
		add_child(new_tile)
		new_tile.add_to_container(expression_container)
	
	for tile in get_children():
		tile.queue_free()
		
