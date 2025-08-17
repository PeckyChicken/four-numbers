extends Tile
class_name OperationTile

@export var operation: String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	$Operation.text = operation

func find_overlap():
	super()
	if overlap == root:
		operation_container.reset_stock()

func quick_move():
	super()
	if previous_parent is OperationContainer:
		operation_container.reset_stock()
