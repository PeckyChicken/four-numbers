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

var target = 22
var target_tile: NumberTile

var starting_numbers: Array[int] = [12,54,66,67]
@onready var NUMBER_TILE_SCENE: PackedScene = load("res://number_tile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_target_tile()
	create_number_tiles(starting_numbers)

func create_target_tile():
	for prev_tile in $Target/Symbols.get_children():
		prev_tile.queue_free()
	target_tile = NUMBER_TILE_SCENE.instantiate()
	target_tile.type = Tiles.STATIC
	target_tile.number = target
	target_tile.expression = "Target"
	
	$Target/Symbols.add_child(target_tile)

func create_number_tiles(numbers: Array[int]):
	for number in numbers:
		var new_tile: NumberTile = NUMBER_TILE_SCENE.instantiate()
		new_tile.type = Tiles.NUMBER
		new_tile.number = number
		new_tile.expression = ""
		new_tile.draggable = true
		add_child(new_tile)
		new_tile.add_to_container($Storage/Symbols,Vector2.INF)
		
