extends Tile
class_name OperationTile

@export var operation: String = ""

var clicked: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	$Operation.text = operation

func find_overlap():
	super()
	if overlap == root:
		operation_container.reset_stock()

func quick_move(container=null):
	super(container)
	if previous_parent is OperationContainer:
		operation_container.reset_stock()

func _process(delta: float) -> void:
	super(delta)
	
	if draggable and not dragging:
		if parent_container == null:
			if get_global_rect().intersects(operation_container.get_global_rect()):
				queue_free()
	
func _on_click(event: InputEvent):
	if event.is_pressed():
		clicked = true
		Events.PlaySound.emit("pick_up_operation",global_position)
	else:
		if clicked:
			clicked = false
			if operation == "=":
				Events.ResetTiles.emit()
				Events.PlaySound.emit("drop_operation",global_position)
				
	
	if draggable:
		super(event)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_on_click(event)

func _input(event: InputEvent):
	var temp_dragging = dragging
	super(event)
	if just_released == 1 and temp_dragging:
		Events.PlaySound.emit("drop_operation",global_position)
