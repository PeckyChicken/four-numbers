extends Control
class_name Root

enum Tiles{
	NUMBER,
	OPERATION,
	SHADOW,
	STATIC,
	ANSWER
}
@onready var containers: Array[Control] = [$Equation/Expression,$Storage,$Operations,$Equation/Answer]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
