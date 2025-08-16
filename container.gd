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
var children: Array[Tile] = []

@export var container_type: Type

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		children.append(child as Tile)
	length = len(children)
	if max_size >= 0:
		assert (length <= max_size,"Too many children: Length: %s, Max: %s, Children: %s"%[length,max_size,children])

func remove_tile(child):
	if child in children:
		children.remove_at(children.find(child))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	length = len(children)
	pivot_offset = size/2
	
	var i = length-1
	var backwards_children = children.duplicate()
	
	for child in backwards_children:
		if not is_instance_valid(child):
			children.remove_at(i)
			length -= 1
		i -= 1
	
