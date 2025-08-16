extends HBoxContainer
class_name NumberContainer

enum Type {
	OPERATION,
	STORAGE,
	EXPRESSION,
	ANSWER
}

@export var max_size: int = -1 ## The maximum size of the container. Negative means infinite.
@export var allowed_tiles: Array[Root.Tiles] = [Root.Tiles.SHADOW]

var length: int = 0

@export var container_type: Type

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	length = get_child_count()
	if max_size >= 0:
		assert (length <= max_size,"Too many children: Length: %s, Max: %s, Children: %s"%[length,max_size,get_children()])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:

	length = get_child_count()
	pivot_offset = size/2
	pivot_offset = size/2
	
