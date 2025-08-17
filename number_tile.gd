extends Tile
class_name NumberTile

@export var number: int = 0
@export var expression: String = ""
var history: Array[Variant] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Number.text = str(number)
	if len(str(number)) > 2:
		$Number.add_theme_font_size_override("normal_font_size", 50 - 5*(len(str(number))-2))
	$Equation.text = expression
	if expression:
		$Number.anchor_bottom = 0.9
		if not history:
			history = expression.split(" ")
	else:
		$Number.anchor_bottom = 1
	
	super()

#func quick_move():
	#Events.PlaySound.emit("quick_move_number",global_position)
	#super()

func _on_click(event: InputEvent):
	if not draggable: return
	if event.is_pressed():
		Events.PlaySound.emit("pick_up_number",global_position)

	super(event)

func _input(event: InputEvent):
	var temp_dragging = dragging
	super(event)
	if just_released == 1 and temp_dragging:
		Events.PlaySound.emit("drop_number",global_position)
		
