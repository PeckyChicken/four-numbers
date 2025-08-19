extends Control
class_name Tile

@export var draggable: bool = false

var extra_data: Dictionary = {}

var movement: float = 0.0
const CLICK_THRESHOLD = 5.0

var dragging: bool = false
var drag_offset: Vector2
var mouse_pos: Vector2

var just_released: int = 0

@export var type: Root.Tiles

@onready var root: Root = get_tree().root.get_child(get_tree().root.get_child_count()-1)
@onready var overlap: Control = root

@onready var shadow_tile: PackedScene = load("res://shadow_tile.tscn")

@onready var expression_container: ExpressionContainer = root.get_node("Equation/Expression/Symbols")
@onready var answer_container: AnswerContainer = root.get_node("Equation/Answer/Symbols")
@onready var storage_container: NumberContainer = root.get_node("Storage/Symbols")
@onready var operation_container: OperationContainer = root.get_node("Operations/Symbols")

var parent_container: NumberContainer
var previous_parent: NumberContainer

var shadow: Tile
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.TileCreated.emit(self)
	if get_parent() is NumberContainer:
		parent_container = get_parent()
		previous_parent = parent_container

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_pos = event.position
	if event is InputEventMouseButton and not event.is_pressed():
		just_released = -1 * just_released
		dragging = false

func add_to_container(container: NumberContainer,temp_position_override=null):
	if container.max_size >= 0:
		assert (container.length(false) <= container.max_size,"Container overflow error: Length: %s, Max Size: %s, Contents: %s" % [container.length(),container.max_size,str(container.get_children())])
	var temp_position
	
	if temp_position_override:
		temp_position = temp_position_override
	else:
		temp_position = global_position
	reparent(container)
	
	parent_container = container
	
	overlap = container
	
	for node in container.get_children():
		if node == self:
			continue
		if node.global_position.x >= temp_position.x:
			container.move_child(node,container.get_child_count()-1)

func delete_shadow():
	if shadow:
		shadow.queue_free()
		shadow = null

func find_overlap():
	delete_shadow()
	
	for other in root.containers:
		if other == self:
			continue
		if other.get_child(0).length(false) >= other.get_child(0).max_size and other.get_child(0).max_size >= 0:
			continue
		if type not in other.get_child(0).allowed_tiles:
			continue
		
		if type == Root.Tiles.NUMBER:
			if other.get_child(0).container_type == NumberContainer.Type.ANSWER and not (self as NumberTile).expression:
				continue
		
		if get_global_rect().intersects(other.get_global_rect()):
			overlap = other
			delete_shadow()
			shadow = shadow_tile.instantiate()
			shadow.position = position
			shadow.type = Root.Tiles.SHADOW
			add_sibling(shadow)
			shadow.add_to_container(overlap.get_child(0),global_position)
			
			return
	
	overlap = root
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not draggable:
		return
	if dragging:
		movement += (mouse_pos + drag_offset - position).length()
		position = mouse_pos + drag_offset
		find_overlap()
		
	else:
		delete_shadow()
		if just_released == 1:
			just_released = 0
			
			if movement < CLICK_THRESHOLD:
				root.moves += 1
				quick_move()
				return
		if overlap in root.containers:
			
			if not parent_container == overlap.get_child(0):
				root.moves += 1
				add_to_container(overlap.get_child(0))
				if parent_container is AnswerContainer:
					parent_container.recreate_expression()

func quick_move():
	if previous_parent in [storage_container,operation_container]:
		add_to_container(expression_container,Vector2.INF)
	elif previous_parent == answer_container:
		add_to_container(storage_container,Vector2.INF)
	elif previous_parent == expression_container:
		
		if self is NumberTile:
			add_to_container(storage_container,Vector2.INF)
		elif self is OperationTile:
			queue_free()

func _on_click(event) -> void:
	movement = 0
	just_released = -1
	if parent_container:
		previous_parent = parent_container
		parent_container = null
	
	if type == Root.Tiles.ANSWER:
		type = Root.Tiles.NUMBER
		extra_data["expression"].clear()
		
	reparent(root)
	root.move_child(self,root.get_child_count()-1)
	drag_offset = position - mouse_pos
	dragging = event.is_pressed()

func _on_gui_input(event: InputEvent) -> void:
	if not draggable:
		return
	if event is InputEventMouseButton:
		_on_click(event)
