class_name ErrorTile
extends Tile

var message: String
var output: String = "###"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	$Output.text = output
	$Message.text = message


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
