extends Tile
class_name OperationTile

@export var operation: String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	draggable = true
	$Operation.text = operation
