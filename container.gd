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


@export var container_type: Type

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if max_size >= 0:
		assert (length() <= max_size,"Too many children: Length: %s, Max: %s, Children: %s"%[length(),max_size,get_children()])

func length(include_shadow=true) -> int:
	var _length = 0
	for child in get_children():
		if include_shadow or child.type != Root.Tiles.SHADOW:
			_length += 1
			continue
	return _length
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:

	pivot_offset = size/2
	pivot_offset = size/2
	
