class_name WinScreen
extends Control

@onready var root: Root = $".."

var time: float
var moves: int
var solution: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Stats/VBoxContainer/HBoxContainer/Time.text = "[img]hourglass.png[/img] %s" % [format_time(int(time))]
	$Stats/VBoxContainer/HBoxContainer/Moves.text = "[img]swapping.png[/img] %s " % [str(moves)]
	$Stats/VBoxContainer/Panel/Solution.text = solution
	fade_on()

func format_time(seconds: int):
	@warning_ignore("integer_division")
	var minutes = seconds / 60
	var secs = seconds % 60
	return str(minutes) + ":" + str(secs).pad_zeros(2)

func fade_on():
	var tween: Tween = create_tween()
	
	var tween_offs: Array = root.containers + [$"../Target",$"../Equation/equals"]
	tween_offs.shuffle()
	
	for container in tween_offs:
		tween.tween_property(container,"modulate:a",0.0,0.25)
	
	tween.tween_property($Fade,"modulate:a",1.0,0.25)
	
	tween.tween_property($Stats,"modulate:a",1.0,0.5)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
