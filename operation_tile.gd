extends Tile
class_name OperationTile

@export var operation: String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	$Operation.text = operation

func find_overlap():
	super()
	if overlap == root:
		operation_container.reset_stock()

func quick_move():
	super()
	if previous_parent is OperationContainer:
		operation_container.reset_stock()

func _process(delta: float) -> void:
	super(delta)
	
	if not dragging:
		if parent_container == null:
			if get_global_rect().intersects(operation_container.get_global_rect()) and draggable:
				queue_free()
	
func _on_click(event: InputEvent):
	if not draggable: return
	if event.is_pressed():
		Events.PlaySound.emit("pick_up_operation",global_position)

	super(event)

func _input(event: InputEvent):
	var temp_dragging = dragging
	super(event)
	if just_released == 1 and temp_dragging:
		Events.PlaySound.emit("drop_operation",global_position)
