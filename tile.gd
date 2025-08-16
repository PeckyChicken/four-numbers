extends Control
class_name Tile

var draggable: bool = false
var dragging: bool = false
var drag_offset: Vector2
var mouse_pos: Vector2

@onready var root: Root = get_tree().root.get_child(0)
@onready var overlap: Control = root

@onready var shadow_tile: PackedScene = load("res://shadow_tile.tscn")

var shadow: Tile
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_pos = event.position
	if event is InputEventMouseButton and not event.is_pressed():
		dragging = false

func add_to_container(container: NumberContainer,temp_position_override=null):
	if container.max_size >= 0:
		assert (container.length < container.max_size,"Container overflow error: Length: %s, Max Size: %s, Contents: %s" % [container.length,container.max_size,str(container.children)])
	var temp_position
	
	if temp_position_override:
		temp_position = temp_position_override
	else:
		temp_position = global_position
	reparent(container)
	
	container.length += 1
	container.children.append(self)
	
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
		if get_global_rect().intersects(other.get_global_rect()):

			overlap = other
			delete_shadow()
			shadow = shadow_tile.instantiate()
			shadow.position = position
			add_sibling(shadow)
			shadow.add_to_container(overlap.get_child(0),global_position)
			
			return
	
	overlap = root
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not draggable:
		return
	if dragging:
		position = mouse_pos + drag_offset
		find_overlap()
		
	else:
		delete_shadow()
		if overlap in root.containers:
			
			if not get_parent() == overlap.get_child(0):
				add_to_container(overlap.get_child(0))

func _on_gui_input(event: InputEvent) -> void:
	if not draggable:
		return
	if event is InputEventMouseButton:
		reparent(root)
		root.move_child(self,root.get_child_count()-1)
		drag_offset = position - mouse_pos
		dragging = event.is_pressed()
