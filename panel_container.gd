extends PanelContainer


@onready var MAIN_SCENE: PackedScene = load("res://main.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$CalendarButton._create_calendar()
	pass

func date_selected(date,__):
	date["hour"] = 0
	date["minute"] = 0
	date["second"] = 0
	var new_scene: Root = MAIN_SCENE.instantiate()
	new_scene.date = date
	new_scene.date_override = true
	get_tree().root.add_child(new_scene)
	new_scene.set_date()
	get_parent().queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
