class_name ShadowTile
extends Tile


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	Events.ResetTiles.connect(queue_free)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
