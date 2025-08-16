extends Tile
class_name NumberTile

@export var number: int = 0
@export var equation: String = ""


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	draggable = true
	$Number.text = str(number)
	$Equation.text = equation
	if equation:
		$Number.anchor_bottom = 0.9
	else:
		$Number.anchor_bottom = 1
