extends HBoxContainer
class_name NumberContainer

@export var max_size: int = -1 ## The maximum size of the container. Negative means infinite.

var length: int = 0
var children: Array[Tile] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		children.append(child as Tile)
	length = len(children)
	if max_size >= 0:
		assert (length <= max_size,"Too many children: Length: %s, Max: %s, Children: %s"%[length,max_size,children])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#$"..".size = size + Vector2(20,20)
	pivot_offset = size/2
	var i = 0
	for child in children.duplicate():
		if not is_instance_valid(child):
			children.remove_at(i)
			length -= 1
		i += 1
	
	length = len(children)
