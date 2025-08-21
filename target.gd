class_name Target
extends PanelContainer

var number_range := Vector2i(2,60)
var number_count := 4
var target_range := Vector2i(4,20) * number_count

var solution: String

var OPS = ["+","-","*","/"]

@onready var root: Root = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	
	if root.difficulty == 0:
		OPS = ["+","-"]
	
	root.target = -1
	
	while root.target == -1:
		root.starting_numbers = create_numbers(root.puzzle_seed)
		root.target = create_target(root.starting_numbers,root.puzzle_seed)
		root.puzzle_seed += 1
	
	root.puzzle_seed -= 1
	
	
	root.create_number_tiles(root.starting_numbers)
	root.create_target_tile()
	

func create_numbers(puzzle_seed:int=-1) -> Array[int]:
	if puzzle_seed != -1:
		seed(puzzle_seed)
	var numbers: Array[int] = []
	for __ in range(number_count):
		var n = randi_range(number_range.x,number_range.y)
		while n in numbers:
			n = randi_range(number_range.x,number_range.y)
		numbers.append(n)
	
	numbers.sort()
	return numbers

func evaluate_op(num1:float,num2:float,op:String) -> float:
	assert(op in OPS,"Operator %s is not recognised. Valid operators are %s" % [op,", ".join(OPS)])
	if op == "+":
		return num1 + num2
	elif op == "-":
		return num1 - num2
	elif op == "*":
		return num1 * num2
	elif op == "/":
		return num1 / num2
	
	assert(false,"How did operator %s miss the previous assertion?" % [op])
	return -INF

func check_one_operation(numbers,target):
	for num1 in numbers:
		for num2 in numbers:
			for op in OPS:
				if evaluate_op(num1,num2,op) == target:
					return true
	return false

func create_target(numbers: Array[int],puzzle_seed:int) -> int:
	numbers = numbers.duplicate()
	var target: int = -1
	var attempts: int = 0
	var start = true
	
	seed(puzzle_seed)
	while start or target in numbers or target_range.x > target or target_range.y < target or check_one_operation(numbers,target):
		if attempts >= 50:
			return -1
		attempts += 1
		start = false
		solution = ""
		target = -1
		numbers.shuffle()
		
		var used_operations: Array[String] = []
		
		var index = -1
		while index < len(numbers)-1:
			index += 1
			var number = numbers[index]
			
			if target == -1:
				target = number
				solution = str(number)
				continue
			
			var operation: String
			
			if root.difficulty == 1 and index == len(numbers)-1 and "*" not in used_operations:
				operation = "*"
			else:
				operation = OPS.pick_random()
				while "*" in used_operations and operation == "*":
					operation = OPS.pick_random()
						
			used_operations.append(operation)
			var evaluation = evaluate_op(target,number,operation)
			
			if evaluation != round(evaluation) or abs(evaluation) == INF:
				used_operations.pop_back()
				index -= 1
				continue
			
			target = int(evaluation)
			solution += operation + str(number)
	
	return target

func _process(_delta: float) -> void:
	pass
