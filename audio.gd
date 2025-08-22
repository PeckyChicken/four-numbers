extends Control

var cache: Dictionary[String,AudioStream] = {}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	Events.PlaySound.connect(play_sound)

func play_sound(sound:String,location:Vector2):
	var player = AudioStreamPlayer2D.new()
	add_child(player)
	
	player.stream = load_sound(sound)
	
	player.position = location
	player.play()
	player.finished.connect(player.queue_free)

func load_sound(sound:String):
	if sound not in cache:
		cache[sound] = load("res://Sounds/%s.ogg" % [sound])
	
	return cache[sound]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
