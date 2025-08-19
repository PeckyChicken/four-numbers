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

func _process(delta: float) -> void:
	var temp_just_released = just_released
	super(delta)
	
	if temp_just_released and not dragging:
		if parent_container == null:
			if get_global_rect().intersects(answer_container.get_global_rect()):
				if not answer_container.get_children().any(func(x):return x is ErrorTile):
					return
				if not self.expression:
					return
				root.moves += 1
				for child in answer_container.get_children():
					child.queue_free()
				add_to_container(answer_container)
				answer_container.recreate_expression()



func find_overlap():
	super()
	
	if get_global_rect().intersects(answer_container.get_global_rect()):
		if not answer_container.get_children().any(func(x):return x is ErrorTile):
			return
		if not self.expression:
			return
		overlap = answer_container
		delete_shadow()
		shadow = shadow_tile.instantiate()
		shadow.position = position
		shadow.type = Root.Tiles.SHADOW
		add_sibling(shadow)
		shadow.add_to_container(overlap,global_position)
		
		return

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
		
