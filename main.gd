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

var target = 30
var target_tile: NumberTile
@onready var NUMBER_TILE_SCENE: PackedScene = load("res://number_tile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_target_tile()

func create_target_tile():
	for prev_tile in $Target/Symbols.get_children():
		prev_tile.queue_free()
	target_tile = NUMBER_TILE_SCENE.instantiate()
	target_tile.type = Tiles.STATIC
	target_tile.number = target
	target_tile.expression = "Target"
	
	$Target/Symbols.add_child(target_tile)
