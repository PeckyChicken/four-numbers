extends Tile
class_name NumberTile

@export var number: int = 0
@export var expression: String = ""
var history = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Number.text = str(number)
	$Equation.text = expression
	if expression:
		$Number.anchor_bottom = 0.9
		if history:
			history = expression.split(" ")
	else:
		$Number.anchor_bottom = 1
