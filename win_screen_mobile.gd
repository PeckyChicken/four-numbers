class_name WinScreenMobile
extends WinScreen


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MAIN_SCENE = load("res://mobile.tscn")
	image_load_string = "[img width=50]"
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
